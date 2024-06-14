import 'package:flutter/material.dart';
import 'package:andromeda/utilities/routes.dart' as rt;
import 'package:flutter_localizations/flutter_localizations.dart';

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
        primaryColor: Colors.black,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      onGenerateRoute: rt.Router.generateRoute,
      initialRoute: 'login',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
    );
  }
}
