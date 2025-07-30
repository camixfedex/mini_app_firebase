import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth.
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario de registro.
  String? email; // Variable para almacenar el correo electrónico.
  String? password; // Variable para almacenar la contraseña.
  String? _errorMessage; // Mensaje de error.
  bool _isLoading = false; // Indicador de carga.

  // Función para registrar un nuevo usuario.
  void _registerUser() async {
    // Valida el formulario.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guarda los valores de los campos.
      setState(() {
        _isLoading = true; // Muestra el indicador de carga.
        _errorMessage = null; // Limpia mensajes de error anteriores.
      });
      try {
        // Intenta crear un nuevo usuario con el correo y contraseña.
        await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
        // Si el registro es exitoso, navega a la pantalla principal y reemplaza la ruta.
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        // Captura y muestra errores específicos de Firebase Authentication.
        setState(() {
          _errorMessage = e.message; // Asigna el mensaje de error.
        });
      } finally {
        // Siempre oculta el indicador de carga.
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
        title: Text('Registrarse'), // Título de la barra de la aplicación.
      ),
      body: Center(
        child: SingleChildScrollView( // Permite el desplazamiento.
          padding: const EdgeInsets.all(16.0), // Relleno.
          child: Form(
            key: _formKey, // Asigna la clave global al formulario.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos.
              children: <Widget>[
                // Campo de texto para el correo electrónico.
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    // Validador de correo.
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value; // Guarda el correo.
                  },
                ),
                SizedBox(height: 20), // Espacio vertical.
                // Campo de texto para la contraseña.
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    // Validador de contraseña.
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value; // Guarda la contraseña.
                  },
                ),
                SizedBox(height: 20), // Espacio vertical.
                // Muestra el mensaje de error si existe.
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20), // Espacio vertical.
                // Botón de registro o CircularProgressIndicator.
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _registerUser, // Llama a la función de registro.
                        child: Text('Registrarse'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                // Botón para regresar a la pantalla de login.
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Regresa a la pantalla anterior.
                  },
                  child: Text('¿Ya tienes una cuenta? Inicia sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
