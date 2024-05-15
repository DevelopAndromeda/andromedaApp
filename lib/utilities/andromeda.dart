import 'package:flutter/material.dart';
import 'package:andromeda/utilities/routes.dart' as rt;
//import 'package:provider/provider.dart';

class Andromeda extends StatelessWidget {
  const Andromeda({super.key});

  @override
  Widget build(BuildContext context) {
    /*return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        //ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
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
          brightness: Brightness.dark,
          primarySwatch: Colors.pink,
        ),
        onGenerateRoute: rt.Router.generateRoute,
        initialRoute: 'start',
      ),
    );*/
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
