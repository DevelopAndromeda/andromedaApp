import 'dart:async';

import 'package:flutter/material.dart';
import 'package:appandromeda/utilities/andromeda.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await dotenv.load(fileName: ".env");
    await initLocalStorage();
    runApp(const Andromeda());
    FlutterNativeSplash.remove();
  }, (exception, stackTrace) async {
    debugPrint("${exception}");
    debugPrint("${stackTrace}");
    FlutterNativeSplash.remove();
  });
}
