import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:andromeda/Witgets/bottomBar.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 154, 126, 43),
        title: const Text('New Your City'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => {},
        ),
        actions: const [
          Icon(Icons.person_pin),
          SizedBox(
            width: 10,
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: CupertinoTextField(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  placeholder: "Seach for shop & restaurants",
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      color: Color(0xff7b7b7b),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xfff7f7f7),
                      borderRadius: BorderRadius.circular(50)),
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 12,
                      fontFamily: 'Exo Regular'),
                )),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          '¡Hola Mundo!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: MyBottomBar(
        index: 0,
      ),
    );
  }
}
