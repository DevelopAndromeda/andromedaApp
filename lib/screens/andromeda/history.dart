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
      body: ListView(
        padding: const EdgeInsets.all(5.0),
        children: [
          _buildCard(
            'Prueba',
            'Recuerda que tu reservación',
            'assets/ExampleRest.png',
            3, // Número de personas
          ),
          _buildCard(
            'Titulo 2',
            'Descripción 2',
            'assets/ExampleRest1.png',
            5, // Número de personas
          ),
          _buildCard(
            'Titulo 3',
            'Descripción 3',
            'assets/ExampleRest2.png',
            2, // Número de personas
          ),
        ],
      ),
      bottomNavigationBar: MyBottomBar(
        index: 1,
      ),
    );
  }

  Widget _buildCard(
      String title, String description, String imagePath, int numberOfPeople) {
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 10,
      child: Stack(
        children: <Widget>[
          // Imagen a la izquierda
          Positioned(
            left: 0,
            top: 15,
            bottom: 15,
            child: Container(
              width: 150,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Título, descripción y número de personas a la derecha
          Positioned(
            left: 120,
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
                  const SizedBox(height: 10),
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue, // Cambia el color del icono aquí
                    ),
                    onPressed: () {
                      // Acción cuando se presiona "Modificar"
                      // Puedes agregar tu lógica aquí
                    },
                  ),
                  const Text(
                    'Modificar',
                    style: TextStyle(
                      color: Colors.blue, // Cambia el color del texto aquí
                    ),
                  ),
                  const SizedBox(height: 1),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red, // Cambia el color del icono aquí
                    ),
                    onPressed: () {
                      // Acción cuando se presiona "Eliminar"
                      // Puedes agregar tu lógica aquí
                    },
                  ),
                  const Text(
                    'Eliminar',
                    style: TextStyle(
                      color: Colors.red, // Cambia el color del texto aquí
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
