import 'package:andromeda/screens/auth%20rest/Login/login_page_rest.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/screens/auth%20costum/Login/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InicioRest(),
    );
  }
}

class InicioRest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ocupa todo el ancho disponible
        height: double.infinity, // Ocupa todo el alto disponible
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 154, 126, 43), // Fondo dorado
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 234, 234, 234),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '¿Cómo deseas iniciar sesión?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 234, 234, 234),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPageRest()),
                  );
                },
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30), // Redondea las esquinas
                    child: Image.asset(
                      'assets/IniciarSesionRest.png', // Ruta de la primera imagen
                      fit: BoxFit.scaleDown, // Ajusta la imagen para cubrir el contenedor
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLoginPage()),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Redondea las esquinas
                    child: Image.asset(
                      'assets/IniciarSesionCliente.png', // Ruta de la segunda imagen
                      fit: BoxFit.contain, // Ajusta la imagen para cubrir el contenedor
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

