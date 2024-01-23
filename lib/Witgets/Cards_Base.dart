import 'package:flutter/material.dart';

class CardsBase extends StatelessWidget {
  final String imagenAsset;
  final String nombreRestaurante;
  final String tipoComida;
  final String horariosAtencion;

  CardsBase({
    required this.imagenAsset,
    required this.nombreRestaurante,
    required this.tipoComida,
    required this.horariosAtencion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del restaurante desde assets
          Container(
            height: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagenAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido del restaurante
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del restaurante
                Text(
                  nombreRestaurante,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                // Tipo de comida
                Text(
                  'Tipo de Comida: $tipoComida',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 8.0),
                // Horarios de atención
                Text(
                  'Horarios de Atención: $horariosAtencion',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Ejemplo de Cards'),
      ),
      body: ListView(
        // Utilizamos ListView para mostrar múltiples Cards
        children: [
          CardsBase(
            imagenAsset: 'assets/restaurante1.jpg',
            nombreRestaurante: 'Restaurante Ejemplo 1',
            tipoComida: 'Comida Internacional',
            horariosAtencion: 'Lun-Vie: 10:00 AM - 8:00 PM',
          ),
          CardsBase(
            imagenAsset: 'assets/restaurante2.jpg',
            nombreRestaurante: 'Restaurante Ejemplo 2',
            tipoComida: 'Comida Asiática',
            horariosAtencion: 'Lun-Dom: 11:00 AM - 9:00 PM',
          ),
          // Agrega más Cards según sea necesario
        ],
      ),
    ),
  ));
}
