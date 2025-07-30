import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth para la autenticación.
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario de login.
  String? email; // Variable para almacenar el correo electrónico.
  String? password; // Variable para almacenar la contraseña.
  String? _errorMessage; // Mensaje de error a mostrar en caso de fallo de autenticación.
  bool _isLoading = false; // Indicador de carga para mostrar un CircularProgressIndicator.

  // Función para iniciar sesión del usuario.
  void _loginUser() async {
    // Valida el formulario.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guarda los valores de los campos del formulario.
      setState(() {
        _isLoading = true; // Muestra el indicador de carga.
        _errorMessage = null; // Limpia cualquier mensaje de error anterior.
      });
      try {
        // Intenta iniciar sesión con el correo y contraseña proporcionados.
        await _auth.signInWithEmailAndPassword(email: email!, password: password!);
        // Si el inicio de sesión es exitoso, navega a la pantalla principal y reemplaza la ruta actual.
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        // Captura y muestra errores específicos de Firebase Authentication.
        setState(() {
          _errorMessage = e.message; // Asigna el mensaje de error de Firebase.
        });
      } finally {
        // Siempre oculta el indicador de carga al finalizar la operación.
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'), // Título de la barra de la aplicación.
      ),
      body: Center(
        child: SingleChildScrollView( // Permite el desplazamiento si el contenido es demasiado grande.
          padding: const EdgeInsets.all(16.0), // Relleno alrededor del contenido.
          child: Form(
            key: _formKey, // Asigna la clave global al formulario.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente.
              children: <Widget>[
                // Campo de texto para el correo electrónico.
                TextFormField(
                  keyboardType: TextInputType.emailAddress, // Tipo de teclado para correo.
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico', // Etiqueta del campo.
                    border: OutlineInputBorder(), // Borde del campo.
                    prefixIcon: Icon(Icons.email), // Icono a la izquierda del campo.
                  ),
                  validator: (value) {
                    // Validador: verifica si el campo está vacío o si el formato del correo es inválido.
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value; // Guarda el valor del campo cuando el formulario es guardado.
                  },
                ),
                SizedBox(height: 20), // Espacio vertical.
                // Campo de texto para la contraseña.
                TextFormField(
                  obscureText: true, // Oculta el texto para la contraseña.
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    // Validador: verifica si el campo está vacío o si la contraseña es muy corta.
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value; // Guarda el valor de la contraseña.
                  },
                ),
                SizedBox(height: 20), // Espacio vertical.
                // Muestra el mensaje de error si existe.
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red), // Estilo del texto de error.
                    textAlign: TextAlign.center, // Alineación del texto.
                  ),
                SizedBox(height: 20), // Espacio vertical.
                // Botón de inicio de sesión o CircularProgressIndicator si está cargando.
                _isLoading
                    ? CircularProgressIndicator() // Muestra el indicador de carga.
                    : ElevatedButton(
                        onPressed: _loginUser, // Llama a la función de login al presionar.
                        child: Text('Iniciar Sesión'), // Texto del botón.
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Relleno del botón.
                          textStyle: TextStyle(fontSize: 18), // Estilo del texto del botón.
                        ),
                      ),
                // Botón para navegar a la pantalla de registro.
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Navega a la ruta de registro.
                  },
                  child: Text('¿No tienes una cuenta? Regístrate aquí'), // Texto del botón.
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}