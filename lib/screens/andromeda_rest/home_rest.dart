import 'package:andromeda/screens/andromeda_rest/menu.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/witgets/colores_base.dart';

class MyHomeRestPage extends StatefulWidget {
  const MyHomeRestPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomeRestPageState createState() => _MyHomeRestPageState();
}

class _MyHomeRestPageState extends State<MyHomeRestPage> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  late Future<Map<String, dynamic>> usuario;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(changeSalida: () {}),
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: const Text(
          'Panel de Administracion',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
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
                Stack(children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/Profile.png"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue),
                      child: const Icon(
                        Icons.edit_document,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Mi cuenta",
              style: TextStyle(fontSize: 32, color: Colors.black),
            ),
            const SizedBox(height: 3),
            const Text(
              "Informacion de la cuenta",
              style: TextStyle(fontSize: 21, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              "Informacion de Contacto",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "${_firstController.text} ${_lastController.text}",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff323232),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _mailController.text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff323232),
              ),
            ),
            /*SizedBox(height: 10),
            Text("Teléfono: $telefono"),*/
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyConfigProfilePage(),
                      ));*/
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Editar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
