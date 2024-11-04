import 'package:appandromeda/blocs/generate_orden/orden_cubit.dart';
import 'package:appandromeda/services/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/route/routes.dart' as rt;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:appandromeda/services/auth.dart';
import 'package:appandromeda/services/customer.dart';

import 'package:appandromeda/blocs/login/login_bloc.dart';
import 'package:appandromeda/blocs/user/user_sesion_bloc.dart';
import 'package:appandromeda/blocs/bottom/bottom_navigation_bloc.dart';

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
    CustomerService customerService = CustomerService();
    OrderService orderService = OrderService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthLogic(authService)),
        BlocProvider(create: (_) => UserSesionLogic(customerService)),
        BlocProvider(create: (_) => BottomNavigationBloc()),
        BlocProvider(create: (_) => OrdenLogic(orderService))
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
        initialRoute: 'home',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
        ],
      ),
    );
  }
}
