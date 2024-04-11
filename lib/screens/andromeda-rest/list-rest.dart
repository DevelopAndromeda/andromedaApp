import 'package:flutter/material.dart';

class ListRest extends StatefulWidget {
  const ListRest({super.key});

  @override
  State<ListRest> createState() => _ListRestState();
}

class _ListRestState extends State<ListRest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de restaurantes'),
      ),
      body: Center(
        child: ImageCard(
          image: AssetImage('assets/image1.jpg'),
          title: 'Imagen Ejemplo De Restaurante',
          onModify: () {
            // Aquí puedes implementar la lógica para modificar la imagen
            print('Modificar imagen');
          },
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final VoidCallback onModify;

  ImageCard({
    required this.image,
    required this.title,
    required this.onModify,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image(
            image: image,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onModify,
            child: Text('Modificar'),
          ),
        ],
      ),
    );
  }
}