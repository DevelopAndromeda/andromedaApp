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
    return SizedBox(
      width: 500, // Ancho deseado
    height: 40, // Alto deseado
    child: ElevatedButton(
 onPressed: onPressed, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  ),
                  child: Text(text,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white),),

    ),
                 
                  );
  }
}
