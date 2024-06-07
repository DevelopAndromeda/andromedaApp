import 'package:flutter/material.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key, required this.index});
  //const MyBottomBar({super.key});
  final int index;

  @override
  _MyBottomPageBar createState() => _MyBottomPageBar();
}

class _MyBottomPageBar extends State<MyBottomBar> {
  //int _currentIndex = 2;

  Map<int, String?> rutas = {
    0: 'search',
    1: 'history',
    2: 'home',
    3: 'saved',
    //4: 'notifications',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.index,
      onTap: (index) {
        //print(index);
        //Navigator.of(context).pushNamed(rutas[index].toString());

        Navigator.of(context).pushNamedAndRemoveUntil(
            rutas[index].toString(), (Route<dynamic> route) => false);
      },
      selectedIconTheme: const IconThemeData(
        color: Color.fromARGB(255, 19, 19, 18),
      ), //Colores del iconos
      selectedLabelStyle: const TextStyle(
        color: Color.fromARGB(255, 19, 19, 18),
      ), //Colores de Label Nota: No hace cambios
      unselectedFontSize: 8,
      selectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'BUSQUEDA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'HISTORIAL',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'INICIO',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          label: 'GUARDADO',
        ),
        /*BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'NOTIFICACIONES',
        ),*/
      ],
    );
  }
}
