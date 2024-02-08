import 'package:andromeda/Witgets/Others/Cards_Base.dart';
import 'package:andromeda/screens/andromeda/history.dart';
import 'package:andromeda/screens/andromeda/notifications.dart';
import 'package:andromeda/screens/andromeda/saved.dart';
import 'package:andromeda/screens/andromeda/search.dart';
import 'package:andromeda/screens/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';

//Codigo solo eficiente para correr la aplicacion mientras se hace el enturamiento
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andromeda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber, // Color dorado para el AppBar
        primaryIconTheme: IconThemeData(color: Colors.white), // Iconos blancos
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

//Funcionalidad del NavBar

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 2; //Inicializador del nav bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Inicio de AppBar
      appBar: AppBar(
        flexibleSpace: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.person,
                size: 30, // Tamaño del icono
                color: Colors.white, // Color del icono
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfilePage(),
                    ));
              },
            ),
            Spacer(),
            // Spacer se utiliza para empujar el título al centro
            const Center(
              child: Text(
                'Andromeda',
                style: TextStyle(
                  fontSize: 24, // Tamaño del texto
                  color: Colors.white, // Color del texto
                ),
              ),
            ),
            Spacer(),

            IconButton(
              icon: const Icon(
                Icons.exit_to_app_rounded,
                size: 30, // Tamaño del icono
                color: Colors.white, // Color del icono
              ),
              onPressed: () {
                // Acción al presionar el icono de perfil
              },
            ),
          ],
        ),
      ),
      //Fin del app bar
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedIconTheme: IconThemeData(
            color: Color.fromARGB(255, 154, 126, 43)), //Colores del iconos
        selectedLabelStyle: TextStyle(
            color: Color.fromARGB(
                255, 154, 126, 43)), //Colores de Label Nota: No hace cambios
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return MySearchPage();
      case 1:
        return MyHistoryPage();
      case 2:
        return Home();
      case 3:
        return MySavedPage();
      case 4:
        return MyNotificationsPage();
      default:
        return Container();
    }
  }
}

//Widget contenedor de Home
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CardsBase();
  }
}
