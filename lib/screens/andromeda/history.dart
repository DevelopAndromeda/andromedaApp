import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(16.0),
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
            'assets/image2.jpg',
            5, // Número de personas
          ),
          _buildCard(
            'Titulo 3',
            'Descripción 3',
            'assets/image3.jpg',
            2, // Número de personas
          ),
          _buildCard(
            'Titulo 4',
            'Descripción 4',
            'assets/image4.jpg',
            4, // Número de personas
          ),
          _buildCard(
            'Titulo 5',
            'Descripción 5',
            'assets/image5.jpg',
            1, // Número de personas
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
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: Stack(
        children: <Widget>[
          // Imagen a la izquierda
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
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
            left: 150,
            top: 2,
            right: 70,
            bottom: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
          // Botones de Modificar y Cancelar en la parte inferior derecha
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción cuando se presiona "Modificar"
                      // Puedes agregar tu lógica aquí
                    },
                  ),
                  const Text('Modificar'),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      // Acción cuando se presiona "Cancelar"
                      // Puedes agregar tu lógica aquí
                    },
                  ),
                  const Text('Cancelar'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
