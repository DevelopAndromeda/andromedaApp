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
        body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Imagen de portada
                Image.asset(
                  "assets/Black.jpg", // Reemplaza con la ruta de tu imagen de portada
                  height: 200, // Ajusta la altura según tus necesidades
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 100,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/Profile.png"),
                  ),
                ),
                // Imagen de perfil
              ],
            ),
            SizedBox(height: 20),
            Text("Nombre:"),
            SizedBox(height: 10),
            Text("Apellido: "),
            SizedBox(height: 10),
            Text("Correo: "),
            /*SizedBox(height: 10),
            Text("Teléfono: $telefono"),*/
            SizedBox(height: 20),
            SizedBox(
              height: 250,
            ),
         
          ],
        ),
      ),
    );
  }
}
