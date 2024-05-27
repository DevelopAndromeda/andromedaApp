import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class baseButtom extends StatelessWidget {
  String text;
  Function() onPressed;

  baseButtom({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
