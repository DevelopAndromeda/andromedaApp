import 'package:andromeda/Reservacion/Reservación_Example.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/Others/Cards_Base.dart';
import 'package:andromeda/screens/andromeda/history.dart';
import 'package:andromeda/screens/andromeda/notifications.dart';
import 'package:andromeda/screens/andromeda/saved.dart';
import 'package:andromeda/screens/andromeda/search.dart';
import 'package:andromeda/screens/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';

class CardsBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(
            'assets/ExampleRest1.png',
            'Restaurante 1',
            'Comida Italiana',
            '11:00 AM - 9:00 PM',
            context,
            
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String imagePath, String name, String cuisineType, String openingHours, BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 150.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Tipo de Comida: $cuisineType',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Horario de Atención: $openingHours',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0), // Agregar espacio entre el texto y el botón
              ElevatedButton(onPressed: (){
                  // ignore: prefer_const_constructors
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ExampleReservacion()));
              }, child: Text('Reservar Ahora'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
