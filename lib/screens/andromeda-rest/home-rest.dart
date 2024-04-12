import 'package:andromeda/screens/andromeda-rest/alta-rest.dart';
import 'package:andromeda/screens/andromeda-rest/list-reservacion.dart';
import 'package:andromeda/screens/andromeda-rest/list-rest.dart';
import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';


//Uso de pruebas solamente
void main() {
  runApp(MyHomeRestPage());
}

class MyHomeRestPage extends StatefulWidget {
  const MyHomeRestPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomeRestPageState createState() => _MyHomeRestPageState();
}


class _MyHomeRestPageState extends State<MyHomeRestPage> {
  Future<void> getUserData() async {
  }

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Panel de Administración'),
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar a la primera pantalla al presionar el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomeRestPage(),
                  ),
                );
              },
              child: Text('Alta de restaurante'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la segunda pantalla al presionar el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AltaRest(),
                  ),
                );
              },
              child: Text('Restaurantes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la tercera pantalla al presionar el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListRest(),
                  ),
                );
              },
              child: Text('Reservaciones'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la cuarta pantalla al presionar el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => listReservacion(),
                  ),
                );
              },
              child: Text('Cerrar sesion'),
            ),
            
          ],
        ),
      ),
      ),
    );
  }
}
