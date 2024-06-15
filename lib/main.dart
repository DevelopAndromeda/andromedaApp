import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/utilities/andromeda.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:andromeda/blocs/block_observer.dart';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const Andromeda());
}*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // ignore: deprecated_member_use
  BlocOverrides.runZoned(() => runApp(const Andromeda()),
      blocObserver: SimpleBlocObserver());
}
