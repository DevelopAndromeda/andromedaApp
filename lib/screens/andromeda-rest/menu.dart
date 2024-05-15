import 'package:flutter/material.dart';

import 'package:andromeda/services/db.dart';

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
      {'name': 'Alta de Restaurante', 'url': 'alta-rest', 'icon': 0xe533},
      {'name': 'Lista de Restaurantes', 'url': 'list-rest', 'icon': 0xe533},
      {
        'name': 'Lista de Reservaciones',
        'url': 'list-reservation',
        'icon': 0xe533
      },
      {'name': 'Lista de Comentarios', 'url': 'list-reviews', 'icon': 0xe533}
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
          const Text("Mi Perfil",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Ir a mi perfil",
                  style: TextStyle(color: Color(0xff369FFF))),
              InkWell(
                onTap: () {
                  /*Navigator.pop(context);
                  Navigator.of(context).pushNamed('perfil');*/
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff369FFF)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xff369FFF),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));

    menuItem.forEach((element) {
      lista.add(DrawerListTile(
          title: element['name'].toString(),
          icon: Icon(
              IconData(
                int.parse(
                  element['icon'].toString(),
                ),
              ),
              color: Colors.black,
              size: 30),
          onTap: () async {
            Navigator.pop(context);
            Navigator.pushNamed(context, element['url'].toString());
          }));
    });

    lista.add(DrawerListTile(
        icon: const Icon(Icons.login_outlined),
        title: "Cerrar Sesion",
        onTap: () async {
          await serviceDB.instance.cleanAllTable();
          Navigator.of(context).pushNamedAndRemoveUntil(
              'login', (Route<dynamic> route) => false);
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
