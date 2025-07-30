## # Mini-App Flutter con Formulario Validado y Autenticación con Firebase
Este proyecto es una mini-aplicación móvil desarrollada en Flutter que demuestra la implementación de un formulario de ingreso de datos con validaciones, manejo de estado con setState, y autenticación de usuarios (registro e inicio de sesión) utilizando Firebase Authentication. Además, los datos ingresados en el formulario son persistidos en Firebase Firestore y se muestran en tiempo real.

#### Características Principales
**Autenticación de Usuarios:** Permite a los usuarios registrarse e iniciar sesión con su correo electrónico y contraseña utilizando Firebase Authentication.

**Formulario de Datos Personales:** Incluye un formulario para ingresar nombre, edad y correo electrónico.

**Validación de Campos:** Los campos del formulario tienen validaciones para asegurar que no estén vacíos, que la edad sea un número válido y mayor que cero, y que el correo electrónico tenga un formato correcto.

**Manejo de Estado con setState:** Se utiliza setState para actualizar la interfaz de usuario en respuesta a cambios en los datos del formulario y el estado de la autenticación.

**Persistencia de Datos con Firebase Firestore:** Los datos ingresados en el formulario son guardados en una base de datos de Firestore, asociados al usuario autenticado.

**Visualización de Datos en Tiempo Real:** Los datos guardados en Firestore se muestran dinámicamente en una lista dentro de la aplicación, actualizándose en tiempo real.

**Interfaz Amigable:** Diseño simple y funcional para una buena experiencia de usuario.

#### Uso del Formulario y Autenticación
**Autenticación**
Al iniciar la aplicación, serás dirigido a la pantalla de Inicio de Sesión.

**Registro:** Si no tienes una cuenta, haz clic en "¿No tienes una cuenta? Regístrate aquí" para ir a la pantalla de Registro. Ingresa un correo electrónico y una contraseña (mínimo 6 caracteres) para crear una nueva cuenta.

**Inicio de Sesión:** Una vez registrado, regresa a la pantalla de Inicio de Sesión e ingresa tus credenciales. Si el inicio de sesión es exitoso, serás redirigido a la pantalla de Datos Personales y verás un mensaje de bienvenida con tu correo electrónico o ID de usuario.

#### Formulario de Datos Personales
Una vez dentro de la aplicación, en la pantalla de "Datos Personales", encontrarás el formulario para ingresar tu información:

**Nombre:** Campo de texto obligatorio para tu nombre.

**Edad:** Campo numérico obligatorio, debe ser un número entero mayor que cero.

**Correo Electrónico:** Campo de texto obligatorio con validación de formato de correo electrónico.

Al hacer clic en el botón "Guardar Datos", la aplicación validará los campos. Si todos son válidos, los datos se guardarán en tu base de datos de Firestore y aparecerán en la lista "Datos Guardados en Firebase" debajo del formulario. Si hay errores de validación, se mostrarán mensajes debajo de los campos correspondientes.

También hay un botón de "Cerrar Sesión" en la barra superior que te permitirá salir de tu cuenta y regresar a la pantalla de inicio de sesión.

### Capturas de Pantalla

#### Pantalla de Inicio de Sesión
![](https://github.com/camixfedex/mini_app_firebase/blob/main/screenshots/login_screen.png)
#### Pantalla de Registro
![](https://github.com/camixfedex/mini_app_firebase/blob/main/screenshots/registration_screen.png)
#### Registro Guardado en Authentication
![](https://github.com/camixfedex/mini_app_firebase/blob/main/screenshots/authentication_screen.png)
#### Formulario de Datos Personales
![](https://github.com/camixfedex/mini_app_firebase/blob/main/screenshots/form_screen.png)
#### AlertDialog Validado
![](https://github.com/camixfedex/mini_app_firebase/blob/main/screenshots/home_screen_form.png)
#### Datos Guardados en Firestore
![](https://github.com/camixfedex/mini_app_firebase/blob/main/screenshots/firestore_screen.png)
#### Validación de Campos del Formulario
![](https://github.com/camixfedex/mini_app_firebase/blob/main/screenshots/error_screen.png)

### Instalación y Ejecución
Para ejecutar este proyecto localmente, sigue los pasos detallados en la guía de configuración de tu proyecto (asegúrate de tener Flutter SDK y Firebase configurados, y las dependencias instaladas).

#### Clona el Repositorio:

```bash
git clone https://github.com/camixfedex/mini_app_firebase
cd mini_app_firebase
```

#### Configura Firebase:

1. Crea un proyecto en la Consola de Firebase.

3. Registra tus aplicaciones (Android) y descarga los archivos de configuración (google-services.json).

5. Habilita "Email/Password" en Firebase Authentication.

7. Ejecuta flutterfire configure en la raíz de tu proyecto para generar lib/firebase_options.dart.

9. Configura las reglas de seguridad de Firestore para permitir el acceso autenticado a users/{userId}/personal_data.

#### Instala las Dependencias:

```bash
flutter pub get
```

#### Ejecuta la Aplicación:

```bash
flutter run
```
