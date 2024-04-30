import 'package:flutter/material.dart' hide Router;

//Componentes
import 'package:andromeda/screens/andromeda/home.dart';
import 'package:andromeda/screens/andromeda-rest/home-rest.dart';
import 'package:andromeda/screens/andromeda-rest/alta-rest.dart';
import 'package:andromeda/screens/andromeda-rest/list-rest.dart';
import 'package:andromeda/screens/andromeda-rest/list-reservacion.dart';
import 'package:andromeda/screens/andromeda/history.dart';
import 'package:andromeda/screens/andromeda/notifications.dart';
import 'package:andromeda/screens/andromeda/saved.dart';
import 'package:andromeda/screens/andromeda/search.dart';
import 'package:andromeda/screens/andromeda-rest/modificacion-rest.dart';
//Auth
import 'package:andromeda/screens/auth/Login/login.dart';
import 'package:andromeda/screens/auth/Register/register_custom.dart';
import 'package:andromeda/screens/auth/Recover_Password/Recover_password.dart';
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
      case 'alta-rest':
        return MaterialPageRoute(builder: (_) => const AltaRest());
      case 'configurations':
        return MaterialPageRoute(builder: (_) => const MyConfigProfilePage());
      case 'detail':
        //final ID = settings.arguments as int;
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MyDetailPage(
            data: data,
          ),
        );
      case 'home':
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case 'home-rest':
        return MaterialPageRoute(builder: (_) => const MyHomeRestPage());
      case 'history':
        return MaterialPageRoute(builder: (_) => const MyHistoryPage());
      case 'list-rest':
        return MaterialPageRoute(builder: (_) => const ListRest());
      case 'modification':
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ModificacionRestaurante(
                  data: data,
                ));
      case 'list-reservation':
        return MaterialPageRoute(builder: (_) => const listReservacion());
      case 'login':
        //final type = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => MyLoginPage());
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
      case 'RecoverPassword':
        return MaterialPageRoute(builder: (_) => const MyRecoverPassword());
      case 'register':
        final type = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => MyRegisterPage(
                  type: type,
                ));
      case 'register-rest':
        final type = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => MyRegisterPage(
                  type: type,
                ));
      /*case 'register-rest':
        return MaterialPageRoute(
            builder: (_) => const MyRegisterPageRestaurant());*/
      case 'review':
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MyReviewPage(
            data: data,
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
