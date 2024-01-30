import 'package:flutter/material.dart' hide Router;

//Componentes
import 'package:andromeda/screens/andromeda/home.dart';
import 'package:andromeda/screens/andromeda/history.dart';
import 'package:andromeda/screens/andromeda/notifications.dart';
import 'package:andromeda/screens/andromeda/saved.dart';
import 'package:andromeda/screens/andromeda/search.dart';
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
    switch (settings.name) {
      case 'configurations':
        return MaterialPageRoute(builder: (_) => const MyConfigProfilePage());
      case 'detail':
        final ID = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MyDetailPage(
            id: ID,
          ),
        );
      case 'home':
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case 'history':
        return MaterialPageRoute(builder: (_) => const MyHistoryPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const MyLoginPage());
      case 'notifications':
        return MaterialPageRoute(builder: (_) => const MyNotificationsPage());
      case 'search':
        return MaterialPageRoute(builder: (_) => const MySearchPage());
      case 'saved':
        return MaterialPageRoute(builder: (_) => const MySavedPage());
      case 'start':
        return MaterialPageRoute(builder: (_) => const MyStartPage());
      case 'store':
        final ID = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MyStorePage(
            id: ID,
          ),
        );
      case 'profile':
        return MaterialPageRoute(builder: (_) => const MyProfilePage());
      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case 'review':
        final ID = settings.arguments as int;
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
