import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importación para Firestore

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario de datos personales.
  String _name = ''; // Variable para almacenar el nombre.
  String _email = ''; // Variable para almacenar el el correo electrónico.
  int? _age; // Variable para almacenar la edad (puede ser nula).
  String? _welcomeMessage; // Mensaje de bienvenida al usuario.

  // Instancias de Firebase
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  String? _userId; // Para almacenar el ID del usuario actual
  bool _isFirebaseInitialized = false; // Estado para rastrear la inicialización de Firebase

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndAuth(); // Inicializa Firebase y autentica al usuario.
  }

  // Inicializa Firebase y obtiene las instancias de Auth y Firestore.
  Future<void> _initializeFirebaseAndAuth() async {
    try {
      // Obtiene instancias de FirebaseAuth y FirebaseFirestore.
      // Se asume que Firebase.initializeApp ya fue llamado en main.dart.
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;

      // Escucha los cambios en el estado de autenticación para obtener el ID del usuario.
      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          setState(() {
            _userId = user.uid; // Asigna el UID del usuario.
            _setWelcomeMessage(); // Establece el mensaje de bienvenida.
            _isFirebaseInitialized = true; // Marca Firebase como inicializado.
          });
        } else {
          // Si el usuario cierra sesión o no está autenticado.
          setState(() {
            _userId = null;
            _welcomeMessage = null;
            _isFirebaseInitialized = true; // Marca Firebase como inicializado incluso si el usuario es nulo.
          });
          // Navega a la pantalla de login si el usuario no está autenticado y no está ya en esa pantalla.
          if (ModalRoute.of(context)?.settings.name != '/login') {
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      });
    } catch (e) {
      print("Error al inicializar Firebase o autenticar: $e");
      setState(() {
        _isFirebaseInitialized = true; // Asegura que la UI no se quede colgada en caso de error.
      });
      _showMessage('Error al inicializar la aplicación: $e');
    }
  }

  // Establece el mensaje de bienvenida con el correo o UID del usuario autenticado.
  void _setWelcomeMessage() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _welcomeMessage = '¡Bienvenido, ${user.email ?? user.uid}!'; // Usa el correo o el UID.
      });
    }
  }

  // Función para enviar y guardar los datos del formulario en Firestore.
  void _submitForm() async {
    // Valida el formulario.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guarda los valores de los campos.

      // Verifica si el ID de usuario está disponible antes de guardar.
      if (_userId == null) {
        _showMessage('Error: Usuario no autenticado para guardar datos.');
        return;
      }

      try {
        // Guarda los datos en Firestore en la ruta: /users/{userId}/personal_data/{documentId}
        await _firestore
            .collection('users') // Colección de usuarios.
            .doc(_userId!) // Documento del usuario actual.
            .collection('personal_data') // Subcolección para datos personales.
            .add({
          'name': _name,
          'age': _age,
          'email': _email,
          'timestamp': FieldValue.serverTimestamp(), // Añade una marca de tiempo del servidor.
        });

        _showMessage('¡Datos guardados exitosamente!'); // Muestra un mensaje de éxito.

        // Limpia los campos del formulario después de guardar.
        setState(() {
          _name = '';
          _email = '';
          _age = null;
        });
        _formKey.currentState!.reset(); // Restablece el estado del formulario.
      } catch (e) {
        _showMessage('Error al guardar los datos: $e'); // Muestra un mensaje de error.
        print("Error al guardar datos en Firestore: $e");
      }
    }
  }

  // Función auxiliar para mostrar mensajes usando un AlertDialog.
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Función para cerrar la sesión del usuario.
  void _logout() async {
    try {
      await _auth.signOut(); // Cierra la sesión de Firebase.
      Navigator.pushReplacementNamed(context, '/login'); // Navega a la pantalla de login.
    } catch (e) {
      _showMessage('Error al cerrar sesión: $e');
      print("Error al cerrar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Muestra un indicador de carga mientras Firebase se inicializa.
    if (!_isFirebaseInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Cargando...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Datos Personales'),
        actions: [
          // Botón de cerrar sesión en la barra de la aplicación.
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView( // Permite el desplazamiento de todo el contenido.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Muestra el mensaje de bienvenida si existe.
            if (_welcomeMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  _welcomeMessage!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            // Muestra el ID de usuario actual.
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Tu ID de Usuario: ${_userId ?? "Cargando..."}', // Muestra "Cargando..." si el ID es nulo.
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Campo de texto para el nombre.
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu nombre';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  // Campo de texto para la edad.
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Edad',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu edad';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age <= 0) {
                        return 'La edad debe ser un número mayor que cero';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _age = int.tryParse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  // Campo de texto para el correo electrónico.
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu correo electrónico';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor, ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 30),
                  Center(
                    // Botón para guardar los datos del formulario.
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Guardar Datos'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Datos Guardados en Firebase:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // StreamBuilder para mostrar datos de Firestore en tiempo real.
            _userId != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users') // Ruta simplificada para datos de usuario.
                        .doc(_userId!)
                        .collection('personal_data')
                        .orderBy('timestamp', descending: true) // Ordena por marca de tiempo.
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Muestra errores.
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Indicador de carga.
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('No hay datos guardados aún.'); // Mensaje si no hay datos.
                      }

                      // Muestra los datos en una lista.
                      return ListView.builder(
                        shrinkWrap: true, // Permite que ListView ocupe solo el espacio necesario.
                        physics: NeverScrollableScrollPhysics(), // Deshabilita el scroll interno de ListView.
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                              snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nombre: ${data['name'] ?? 'N/A'}', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Edad: ${data['age'] ?? 'N/A'}'),
                                  Text('Correo: ${data['email'] ?? 'N/A'}'),
                                  Text(
                                    'Guardado: ${data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate().toLocal().toString().split('.')[0] : 'N/A'}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Text('Cargando datos del usuario...'), // Mensaje si el ID de usuario aún no está disponible.
          ],
        ),
      ),
    );
  }
}
