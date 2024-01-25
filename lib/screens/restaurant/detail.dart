import 'package:flutter/material.dart';

class MyDetailPage extends StatefulWidget {
  final int id;
  const MyDetailPage({super.key, required this.id});

  @override
  State<MyDetailPage> createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("is Detail Store with id: ${widget.id}"),
    );
  }
}
