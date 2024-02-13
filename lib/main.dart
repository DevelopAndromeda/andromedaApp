import 'package:flutter/material.dart';
//Inhabilitada termporalmente
import 'package:andromeda/utilities/andromeda.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:andromeda/screens/andromeda/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const Andromeda());
}/// Lo dejo comentado solo un segundo para hacer pruebas cuando hagas el enrutamiento puedes cambiarlo 

/*void main ()=> runApp (const AppAndromeda());

class AppAndromeda extends StatefulWidget {
  const AppAndromeda ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pruebas de App',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}*/