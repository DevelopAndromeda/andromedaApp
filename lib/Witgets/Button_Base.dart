import 'Colores_Base.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class baseButtom extends StatelessWidget {

  String text;
  Function () onPressed;
  
  baseButtom({
    required this.text,
    required this.onPressed

  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                  onPressed: onPressed, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    minimumSize: const Size(130, 44),
                    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0), // Redondeo de 10.0
    ),
                  ),
                  child: Text(text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white
                    ),),
                  );
  }
}
