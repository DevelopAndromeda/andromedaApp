import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';

import 'package:andromeda/services/db.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: GestureDetector(
              onTap: () async {
                await serviceDB.instance.cleanAllTable();
                Navigator.pushNamed(context, 'login');
              },
              child: const Text(
                "Cerrar Sesion",
                style: TextStyle(
                    color: Color.fromARGB(255, 154, 126, 43),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        bottomNavigationBar: MyBottomBar(
          index: 2,
        ));
  }
}
