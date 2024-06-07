import 'package:andromeda/screens/user/configurations.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';

import 'package:andromeda/services/db.dart';

import 'package:andromeda/utilities/constanst.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String? nombre;
  String? apellido;
  String? correo;
  String? telefono;

  Future getDataUser() async {
    var usurio = await serviceDB.instance.getById('users', 'id_user', 1);
    if (usurio.isNotEmpty) {
      nombre = usurio[0]['nombre'];
      apellido = usurio[0]['apellido_paterno'];
      correo = usurio[0]['username'];
      telefono = usurio[0]['telefono'] ?? '';
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Inicio de AppBar
      appBar: AppBar(
  backgroundColor: Colors.black,   // Fondo negro
  centerTitle: true,               // Centrar el título
  title: const Text(
    'Andromeda',
    style: TextStyle(
      fontSize: 24,                 // Tamaño de fuente (puedes ajustarlo)
      color: Colors.white,          // Texto blanco
      fontWeight: FontWeight.bold,  // Negrita
    ),
  ),
  actions: [                       // Ícono de salida en la esquina derecha
    IconButton(
      icon: const Icon(
        Icons.exit_to_app_rounded, 
        size: 30,                   // Tamaño del ícono (ajustable)
        color: Colors.white,        // Ícono blanco
      ),
      onPressed: () async {
        closeSession(context);     // Función para cerrar sesión
      },
    ),
  ],
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
                  "assets/Black.jpg", // Reemplaza con la ruta de tu imagen de portada
                  height: 200, // Ajusta la altura según tus necesidades
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                const Positioned(
                  top: 100,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/Profile.png"),
                  ),
                ),
                // Imagen de perfil
              ],
            ),
            const SizedBox(height: 20),
            Text("Nombre: $nombre"),
            const SizedBox(height: 10),
            Text("Apellido: $apellido"),
            const SizedBox(height: 10),
            Text("Correo: $correo"),
            /*SizedBox(height: 10),
            Text("Teléfono: $telefono"),*/
            const SizedBox(height: 20),
            const SizedBox(
              height: 250,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyConfigProfilePage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Modificar Perfil",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomBar(
        index: 2,
      ),
    );
  }
}
