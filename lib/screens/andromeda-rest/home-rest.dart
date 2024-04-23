import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

class MyHomeRestPage extends StatefulWidget {
  const MyHomeRestPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomeRestPageState createState() => _MyHomeRestPageState();
}

class _MyHomeRestPageState extends State<MyHomeRestPage> {
  Future<void> getUserData() async {}

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administración'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar a la segunda pantalla al presionar el botón
                //Navigator.of(context).pushNamedAndRemoveUntil(
                //    'alta-rest', (Route<dynamic> route) => false);
                Navigator.pushNamed(context, 'alta-rest');
              },
              child: Text('Alta de Restaurante'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la tercera pantalla al presionar el botón
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListRest(),
                    ),
                  );*/
                //Navigator.of(context).pushNamedAndRemoveUntil(
                //    'list-rest', (Route<dynamic> route) => false);
                Navigator.pushNamed(context, 'list-rest');
              },
              child: Text('Lista de Restaurantes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la cuarta pantalla al presionar el botón
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listReservacion(),
                    ),
                  );*/
                Navigator.pushNamed(context, 'list-reservation');
                //Navigator.of(context).pushNamedAndRemoveUntil(
                //    'list-reservation', (Route<dynamic> route) => false);
              },
              child: Text('lista de Reservaciones'),
            ),
            ElevatedButton(
                onPressed: () async {
                  await serviceDB.instance.cleanAllTable();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'start', (Route<dynamic> route) => false);
                },
                child: Text('Cerrar Sesion'))
          ],
        ),
      ),
    );
  }
}
