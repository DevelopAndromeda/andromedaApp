import 'package:flutter/material.dart';

class ExampleReservacion extends StatefulWidget {
   ExampleReservacion({super.key});

  @override
  State<ExampleReservacion> createState() => _ExampleReservacionState();
}

class _ExampleReservacionState extends State<ExampleReservacion> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Text('Reservaciones'),
    );
  }
}