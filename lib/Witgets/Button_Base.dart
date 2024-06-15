import 'package:flutter/material.dart';

class baseButtom extends StatelessWidget {
  Widget text;
  Function() onPressed;

  baseButtom({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        minimumSize: const Size(130, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0), // Redondeo de 10.0
        ),
      ),
      child: text,
    );
  }
}
