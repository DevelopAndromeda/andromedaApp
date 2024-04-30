import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/screens/andromeda-rest/menu.dart';

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
      drawer: NavDrawer(changeSalida: () {}),
      appBar: AppBar(
        title: Text('Panel de Administración'),
      ),
      body: Center(
          /*child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'alta-rest');
              },
              child: Text('Alta de Restaurante'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'list-rest');
              },
              child: Text('Lista de Restaurantes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'list-reservation');
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
        ),*/
          ),
    );
  }
}
