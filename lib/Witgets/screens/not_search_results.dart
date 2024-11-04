import 'package:flutter/material.dart';

class NotSearchResults extends StatelessWidget {
  const NotSearchResults({super.key, required this.img});
  final String img;
  //Busqueda_not_results.png

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/screens/$img',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
