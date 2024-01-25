import 'package:flutter/material.dart' hide Router;

//Componentes
import 'package:andromeda/screens/andromeda/home.dart';
import 'package:andromeda/screens/andromeda/search.dart';
import 'package:andromeda/screens/andromeda/history.dart';
//Auth
import 'package:andromeda/screens/auth/Login/login_page.dart';
import 'package:andromeda/screens/auth/Register/registro_page.dart';
//Inicio
import 'package:andromeda/screens/start.dart';
//Users
import 'package:andromeda/screens/user/profile.dart';
import 'package:andromeda/screens/user/configurations.dart';
//Store
import 'package:andromeda/screens/restaurant/detail.dart';
import 'package:andromeda/screens/restaurant/store.dart';
import 'package:andromeda/screens/restaurant/review.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final ID = settings.arguments as int;
    switch (settings.name) {
      case 'detail':
        return MaterialPageRoute(
          builder: (_) => MyDetailPage(
            id: ID,
          ),
        );
      case 'home':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'start':
        return MaterialPageRoute(builder: (_) => const MyStartPage());
      case 'store':
        return MaterialPageRoute(
          builder: (_) => MyStorePage(
            id: ID,
          ),
        );
      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case 'review':
        return MaterialPageRoute(
          builder: (_) => MyReviewPage(
            id: ID,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
