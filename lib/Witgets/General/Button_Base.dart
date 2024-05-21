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
                    backgroundColor: Base_ColorDorado,
                  ),
                  child: Text(text,
                  style: const TextStyle(
                    fontSize: 18),),
                  );
  }
}
