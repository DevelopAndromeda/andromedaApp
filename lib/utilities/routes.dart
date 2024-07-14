import 'package:flutter/material.dart' hide Router;

//Componentes
import 'package:andromeda/screens/andromeda/home.dart';
import 'package:andromeda/screens/andromeda_rest/alta_rest.dart';
import 'package:andromeda/screens/andromeda_rest/list_rest.dart';
import 'package:andromeda/screens/andromeda_rest/list_reservacion.dart';
import 'package:andromeda/screens/andromeda_rest/list_reviews.dart';
import 'package:andromeda/screens/andromeda/history.dart';
import 'package:andromeda/screens/andromeda/notifications.dart';
import 'package:andromeda/screens/andromeda/saved.dart';
import 'package:andromeda/screens/andromeda/search.dart';
import 'package:andromeda/screens/andromeda_rest/modificacion_rest.dart';
import 'package:andromeda/screens/andromeda_rest/reviews.dart';
//Auth
import 'package:andromeda/screens/auth/login.dart';
import 'package:andromeda/screens/auth/register.dart';
import 'package:andromeda/screens/auth/recover_password.dart';
//Inicio
import 'package:andromeda/screens/splash.dart';
//Users
import 'package:andromeda/screens/user/profile.dart';
import 'package:andromeda/screens/user/configurations.dart';
import 'package:andromeda/screens/user/change_password.dart';
//Store
import 'package:andromeda/screens/restaurant/detail.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'alta-rest':
        return MaterialPageRoute(builder: (_) => const AltaRest());
      case 'configurations':
        return MaterialPageRoute(builder: (_) => const MyConfigProfilePage());
      case 'change-password':
        return MaterialPageRoute(builder: (_) => const MyChangePasswordPage());
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
      case 'history':
        return MaterialPageRoute(builder: (_) => const MyHistoryPage());
      case 'list-rest':
        return MaterialPageRoute(builder: (_) => const ListRest());
      case 'list-reviews':
        return MaterialPageRoute(builder: (_) => const ListReview());
      case 'modification':
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ModificacionRestaurante(
                  data: data,
                ));
      case 'list-reservation':
        return MaterialPageRoute(builder: (_) => const ListReservacion());
      case 'login':
        //final type = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => const MyLoginPage());
      case 'notifications':
        return MaterialPageRoute(builder: (_) => const MyNotificationsPage());
      case 'search':
        return MaterialPageRoute(builder: (_) => const MySearchPage());
      case 'saved':
        return MaterialPageRoute(builder: (_) => const MySavedPage());
      case 'splash':
        return MaterialPageRoute(builder: (_) => const MySplashPage());
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
      case 'reviews':
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => Reviews(
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
