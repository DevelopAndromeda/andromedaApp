import 'package:flutter/material.dart';

//import 'package:andromeda/utilities/constanst.dart';
import 'package:andromeda/witgets/colores_base.dart';

class ListTables extends StatefulWidget {
  const ListTables({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListTables createState() => _ListTables();
}

class _ListTables extends State<ListTables> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Background_Color,
        appBar: AppBar(
          title: const Text(
            'Gestion de mesas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            onPressed: () => Navigator.pushNamed(context, 'profile'),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text("En construccion!"),
        ));
  }
}
