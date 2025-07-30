import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Asegura que los widgets de Flutter estén inicializados antes de usar Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase con las opciones por defecto para la plataforma actual.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Ejecuta la aplicación Flutter.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Título de la aplicación.
      title: 'Mini App Flutter',
      // Tema de la aplicación.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Color primario de la aplicación.
        visualDensity: VisualDensity.adaptivePlatformDensity, // Densidad visual adaptable.
      ),
      // Ruta inicial de la aplicación. Si hay un usuario autenticado, va a la pantalla de inicio,
      // de lo contrario, va a la pantalla de login.
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      // Definición de las rutas de navegación de la aplicación.
      routes: {
        '/login': (context) => LoginScreen(), // Ruta para la pantalla de inicio de sesión.
        '/register': (context) => RegistrationScreen(), // Ruta para la pantalla de registro.
        '/home': (context) => HomeScreen(), // Ruta para la pantalla principal (después del login).
      },
    );
  }
}