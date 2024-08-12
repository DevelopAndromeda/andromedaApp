import 'dart:async';

import 'package:flutter/material.dart';
import 'package:andromeda/utilities/andromeda.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import 'package:andromeda/services/background.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

    //await initializeService();
    runApp(const Andromeda());
  }, (exception, stackTrace) async {
    //print("${exception}, ${stackTrace}");
  });
}
