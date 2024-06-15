import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:andromeda/blocs/bottom/bottom_navigation_bloc.dart';

class MyBottomBar extends StatefulWidget {
  //const MyBottomBar({super.key, required this.index});
  const MyBottomBar({super.key});
  //final int index;

  @override
  // ignore: library_private_types_in_public_api
  _MyBottomPageBar createState() => _MyBottomPageBar();
}

class _MyBottomPageBar extends State<MyBottomBar> {
  //int _currentIndex = 2;

  Map<int, String?> rutas = {
    0: 'search',
    1: 'history',
    2: 'home',
    3: 'saved',
    4: 'notifications',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBloc = context.read<BottomNavigationBloc>();

    return BlocBuilder<BottomNavigationBloc, int>(
      builder: (context, currentTabIndex) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: currentTabIndex,
          onTap: (index) => bottomNavigationBloc.add(TabChangeEvent(index)),
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
              icon: ImageIcon(
                AssetImage("assets/LogoBlack.png"),
                color: Color(0xFF3A5A98),
                size: 30,
              ),
              label: 'INICIO',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'GUARDADO',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: 'NOTIFICACIONES',
            ),
          ],
        );
      },
    );
  }
}
