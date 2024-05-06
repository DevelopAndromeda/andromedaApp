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
        backgroundColor: Colors.white,
        flexibleSpace: Row(
          children: [
            Spacer(),
            // Spacer se utiliza para empujar el título al centro
            const Center(
              child: Text(
                'Andromeda',
                style: TextStyle(
                  fontSize: 24, // Tamaño del texto
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: const Icon(
                Icons.exit_to_app_rounded,
                size: 30, // Tamaño del icono
              ),
              onPressed: () async {
                //await serviceDB.instance.cleanAllTable();
                await serviceDB.instance.cleanAllTable();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'login', (Route<dynamic> route) => false);
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
                  "assets/Black.jpg", // Reemplaza con la ruta de tu imagen de portada
                  height: 200, // Ajusta la altura según tus necesidades
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 150,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/Profile.png"),
                  ),
                ),
                // Imagen de perfil
              ],
            ),
            SizedBox(height: 20),
            Text("Nombre: $nombre"),
            SizedBox(height: 10),
            Text("Apellido: $apellido"),
            SizedBox(height: 10),
            Text("Correo: $correo"),
            /*SizedBox(height: 10),
            Text("Teléfono: $telefono"),*/
            SizedBox(height: 20),
            SizedBox(
              height: 250,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyConfigProfilePage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  "Modificar Perfil",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomBar(
        index: 2,
      ),
    );
  }
}
