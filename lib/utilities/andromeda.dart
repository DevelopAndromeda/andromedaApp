import 'package:flutter/material.dart';
import 'package:andromeda/utilities/routes.dart' as rt;

/*class Andromeda extends StatefulWidget {
  const Andromeda({super.key});

  @override
  State<Andromeda> createState() => _MyAndromedaState();
}

class _MyAndromedaState extends State<Andromeda> {
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
        primarySwatch: Colors.pink,
      ),
      darkTheme: ThemeData(
        //Se indica que el tema tiene un brillo oscuro
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
      ),
      onGenerateRoute: rt.Router.generateRoute,
      initialRoute: 'login',
    );
  }
}*/

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
        primarySwatch: Colors.pink,
      ),
      darkTheme: ThemeData(
        //Se indica que el tema tiene un brillo oscuro
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
      ),
      onGenerateRoute: rt.Router.generateRoute,
      initialRoute: 'login',
    );
  }
}
