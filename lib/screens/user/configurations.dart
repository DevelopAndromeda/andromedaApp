import 'package:flutter/material.dart';

class MyConfigProfilePage extends StatefulWidget {
  const MyConfigProfilePage({super.key});

  @override
  State<MyConfigProfilePage> createState() => _MyConfigProfilePageState();
}

class _MyConfigProfilePageState extends State<MyConfigProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
              child: Text(
                'Modificación del perfil',
                style: TextStyle(
                  fontSize: 24, // Tamaño del texto
                  color: Colors.white, // Color del texto
                ),
              ),
            );
  }
}
