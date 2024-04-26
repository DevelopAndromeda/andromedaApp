import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';

import 'package:andromeda/Witgets/bottomBar.dart';

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({Key? key}) : super(key: key);

  @override
  State<MyHistoryPage> createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'), // Título del AppBar
        centerTitle: true, // Centra el título del AppBar
      ),
      body: ListView(
        padding: const EdgeInsets.all(5.0),
        children: [
          _buildCard(
              'Prueba',
              'Recuerda que tu reservación',
              'assets/ExampleRest.png',
              3, // Número de personas
              'reservation'),
          _buildCard(
              'Titulo 2',
              'Descripción 2',
              'assets/ExampleRest1.png',
              5, // Número de personas
              'reservation'),
          _buildCard(
              'Titulo 3',
              'Descripción 3',
              'assets/ExampleRest2.png',
              2, // Número de personas
              'reservation'),
        ],
      ),
      bottomNavigationBar: MyBottomBar(
        index: 1,
      ),
    );
  }

  Widget _buildCard(String title, String description, String imagePath,
      int numberOfPeople, String ruta) {
    return InkWell(
      onTap: () {
        print(ruta);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(ruta, (Route<dynamic> route) => false);
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 10,
        child: SizedBox(
          width: 350,
          height: 150,

          child: Stack(
          children: <Widget>[
            // Imagen a la izquierda
            Positioned(
              left: 10,
              top: 15,
              bottom: 15,
              child: Container(
                width: 100,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Título, descripción y número de personas a la derecha
            Positioned(
              left: 110,
              top: 10,
              right: 65,
              bottom: 5,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Numero de Personas: $numberOfPeople',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            // Botones de Modificar y Eliminar en la parte inferior derecha
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color:
                                Color.fromARGB(255, 2, 2, 2), // Cambia el color del icono aquí
                          ),
                          iconSize: 16,
                          onPressed: () {
                            // Acción cuando se presiona "Modificar"
                            // Puedes agregar tu lógica aquí
                          },
                        ),
                      ],
                    ),
                        // Espacio entre los botones
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 8, 8, 8), // Cambia el color del icono aquí
                          ),
                          iconSize: 16,
                          onPressed: () {
                            // Acción cuando se presiona "Eliminar"
                            // Puedes agregar tu lógica aquí
                          },
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
        
      ),
    );
  }
}
