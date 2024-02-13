import 'package:flutter/material.dart';

class baseTextfield extends StatelessWidget {
  String label;
  String error;
  IconData icon;
  bool obscureText;
  Function(String text) onChanged;

  baseTextfield(
      {required this.label,
      required this.icon,
      required this.onChanged,
      this.error = '',
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        onChanged(value);
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          filled: true,
          fillColor: const Color.fromARGB(255, 249, 235, 208),
          label: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          errorText: error,
          suffixIcon: Icon(icon, color: Colors.grey)),
      obscureText: obscureText,
    );
  }
}
