import 'package:andromeda/screens/andromeda-rest/menu.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/services/db.dart';

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
  Future<void> getUserData() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    if (sesion.isNotEmpty) {
      _firstController.text = sesion[0]['nombre'];
      _lastController.text = sesion[0]['apellido_paterno'];
      _mailController.text = sesion[0]['username'];
    }
    setState(() {});
  }

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
        title: const Text('Panel de Administración'),
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
            Text("Nombre: ${_firstController.text}"),
            const SizedBox(height: 10),
            Text("Apellido: ${_lastController.text}"),
            const SizedBox(height: 10),
            Text("Correo: ${_mailController.text}"),
            /*SizedBox(height: 10),
            Text("Teléfono: $telefono"),*/
            const SizedBox(height: 20),
            const SizedBox(
              height: 250,
            ),
          ],
        ),
      ),
    );
  }
}
