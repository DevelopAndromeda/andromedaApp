import 'package:flutter/material.dart';
import 'package:andromeda/utilities/andromeda.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const Andromeda());
}
