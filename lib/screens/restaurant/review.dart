import 'package:flutter/material.dart';

class MyReviewPage extends StatefulWidget {
  final int id;
  const MyReviewPage({super.key, required this.id});

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("is Review Store with id: ${widget.id}"),
    );
  }
}
