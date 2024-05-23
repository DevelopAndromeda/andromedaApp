import 'package:flutter/material.dart';
import 'package:andromeda/utilities/routes.dart' as rt;

class Andromeda extends StatelessWidget {
  const Andromeda({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Andromeda',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: "Cairo",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primarySwatch: Colors.brown,
        primaryColor: Colors.black,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.brown,
        primaryColor: Colors.black,
      ),
      onGenerateRoute: rt.Router.generateRoute,
      initialRoute: 'login',
    );
  }
}
