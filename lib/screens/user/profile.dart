import 'package:andromeda/screens/user/configurations.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';

import 'package:andromeda/services/db.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String nombre = "John";
  String apellido = "Doe";
  String correo = "john.doe@example.com";
  String telefono = "123-456-7890";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Inicio de AppBar
      appBar: AppBar(
        flexibleSpace: Row(
          children: [
            Spacer(),
            // Spacer se utiliza para empujar el título al centro
            const Center(
              child: Text(
                'Andromeda',
                style: TextStyle(
                  fontSize: 24, // Tamaño del texto
                  color: Colors.white, // Color del texto
                ),
              ),
            ),
            Spacer(),

            IconButton(
              icon: const Icon(
                Icons.exit_to_app_rounded,
                size: 30, // Tamaño del icono
                color: Colors.white, // Color del icono
              ),
              onPressed: () {
                // Acción al presionar el icono de perfil
              },
            ),
          ],
        ),
      ),

      //Inicio de Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Imagen de portada
                Image.asset(
                  "assets/Back.png", // Reemplaza con la ruta de tu imagen de portada
                  height: 200, // Ajusta la altura según tus necesidades
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Imagen de perfil
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/Profile.png"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Nombre: $nombre"),
            SizedBox(height: 10),
            Text("Apellido: $apellido"),
            SizedBox(height: 10),
            Text("Correo: $correo"),
            SizedBox(height: 10),
            Text("Teléfono: $telefono"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyConfigProfilePage(),
                    ));
              },
              child: Text("Modificar Perfil"),
            ),
          ],
        ),
      ),
    );
  }
}
