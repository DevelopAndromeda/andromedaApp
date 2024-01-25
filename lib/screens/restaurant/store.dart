import 'package:flutter/material.dart';

class MyStorePage extends StatefulWidget {
  final int id;
  const MyStorePage({super.key, required this.id});

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("is Store with id: ${widget.id}"),
    );
  }
}
