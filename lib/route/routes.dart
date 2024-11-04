import 'package:flutter/material.dart' hide Router;
import 'screen_export.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'alta-rest':
        return MaterialPageRoute(builder: (_) => const AltaRest());
      case 'configurations':
        return MaterialPageRoute(builder: (_) => const MyConfigProfilePage());
      case 'change-password':
        return MaterialPageRoute(builder: (_) => const MyChangePasswordPage());
      //case 'delete-account':
      //  return MaterialPageRoute(builder: (_) => AccountDeletionScreen());
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
      case 'list-tables':
        return MaterialPageRoute(builder: (_) => const ListTables());
      case 'reviews':
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => Reviews(
            data: data,
          ),
        );
      case 'orden':
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MyOrdenScreen(
            id: id,
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
