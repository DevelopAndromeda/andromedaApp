import 'package:flutter/material.dart';

import 'package:andromeda/utilities/constanst.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.changeSalida});
  final Function changeSalida;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          shrinkWrap: true,
          children: _createContet(context),
        ));
  }

  List<Widget> _createContet(BuildContext context) {
    final menuItem = [
      {
        'name': 'Agregar restaurante',
        'url': 'alta-rest',
        'icon': Icons.add_business
      },
      {
        'name': 'Mis restaurantes',
        'url': 'list-rest',
        'icon': Icons.restaurant
      },
      {
        'name': 'Historial de reservaciones',
        'url': 'list-reservation',
        'icon': Icons.book_online
      },
      {
        'name': 'Lista de comentarios',
        'url': 'list-reviews',
        'icon': Icons.comment
      },
      {
        'name': 'Estado de mesas',
        'url': 'list-tables',
        'icon': Icons.table_restaurant_sharp
      }
    ];
    List<Widget> lista = <Widget>[];
    lista.add(Container(
      height: 100,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: const Color(0xffEBF6FF),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Mi Cuenta",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Informacion de la cuenta",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('home-rest');
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(110, 59, 59, 59)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color.fromARGB(90, 56, 56, 56),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));

    for (var element in menuItem) {
      lista.add(ListTile(
        leading: Icon(
          element['icon'] as IconData, // Convertir explícitamente a IconData
          color: Colors.grey[800],
        ),
        title: Text(
          element['name'].toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: () async {
          Navigator.pop(context);
          Navigator.pushNamed(context, element['url'].toString());
        },
      ));
    }

    lista.add(ListTile(
        leading: const Icon(Icons.login_outlined),
        title: const Text("Cerrar Sesion"),
        onTap: () async {
          closeSession(context);
        }));

    return lista;
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final Icon icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0,
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
