import 'package:flutter/material.dart';

class RatingProgressIndicador extends StatelessWidget {
  const RatingProgressIndicador(
      {super.key, required this.text, required this.value});

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(text)),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: 20,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 15,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}
