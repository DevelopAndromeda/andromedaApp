import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/utilities/routes.dart' as rt;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:andromeda/services/auth.dart';
import 'package:andromeda/blocs/login/login_bloc.dart';
import 'package:andromeda/blocs/bottom/bottom_navigation_bloc.dart';

class Andromeda extends StatefulWidget {
  const Andromeda({super.key});

  @override
  State<Andromeda> createState() => _AndromedaState();
}

class _AndromedaState extends State<Andromeda> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthLogic(authService)),
          BlocProvider(create: (_) => BottomNavigationBloc()),
        ],
        child: MaterialApp(
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
          initialRoute: 'splash',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'),
          ],
        ));
  }
}
