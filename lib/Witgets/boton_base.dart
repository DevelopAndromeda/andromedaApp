import 'package:flutter/material.dart';

class MyBaseButtom extends StatelessWidget {
  const MyBaseButtom({super.key, required this.text, required this.onPressed});

  final Widget text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        minimumSize: Size(130, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0), // Redondeo de 10.0
        ),
      ),
      child: text,
    );
  }
}
