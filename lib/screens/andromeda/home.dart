import 'package:andromeda/Witgets/Cards_Base.dart';
import 'package:andromeda/screens/andromeda/history.dart';
import 'package:andromeda/screens/andromeda/notifications.dart';
import 'package:andromeda/screens/andromeda/saved.dart';
import 'package:andromeda/screens/andromeda/search.dart';
import 'package:flutter/material.dart';
//Codigo solo eficiente para correr la aplicacion mientras se hace el enturamiento
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google NavBar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  int _currentIndex = 2;  //Inicializador del nav bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google NavBar Example'),
      ),
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedIconTheme: IconThemeData(color: Color.fromARGB(255, 154, 126, 43)),  //Colores del iconos
        selectedLabelStyle: TextStyle(color: Color.fromARGB(255, 154, 126, 43)),    //Colores de Label Nota: No hace cambios
        items: [
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
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
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
        return MyNotificationsPage();
      case 4:
        return MySavedPage();
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