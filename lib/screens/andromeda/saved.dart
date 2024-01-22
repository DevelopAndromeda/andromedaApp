import 'package:flutter/material.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({super.key});

  @override
  State<MySavedPage> createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('is Saved'),
    );
  }
}
