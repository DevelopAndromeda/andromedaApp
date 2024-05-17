import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/screens/andromeda-rest/menu.dart';

class MyHomeRestPage extends StatefulWidget {
  const MyHomeRestPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomeRestPageState createState() => _MyHomeRestPageState();
}

class _MyHomeRestPageState extends State<MyHomeRestPage> {
  Future<void> getUserData() async {}

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(changeSalida: () {}),
      appBar: AppBar(
        title: Text('Panel'),
        backgroundColor: Colors.black,
      ),
      body: Center(),
    );
  }
}
