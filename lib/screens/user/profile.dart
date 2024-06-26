import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/inicio/user/user_bloc.dart';

import 'package:andromeda/witgets/profile_menu.dart';

import 'package:andromeda/utilities/constanst.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final UserBloc _userBloc = UserBloc();

  @override
  void initState() {
    _userBloc.add(GetUser());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Inicio de AppBar
        appBar: AppBar(
          backgroundColor: Colors.black, // Fondo negro
          centerTitle: true, // Centrar el título
          title: const Text(
            'Andromeda',
            style: TextStyle(
              fontSize: 24, // Tamaño de fuente (puedes ajustarlo)
              color: Colors.white, // Texto blanco
              fontWeight: FontWeight.bold, // Negrita
            ),
          ),
          leading: BackButton(
            onPressed: () => Navigator.pushNamed(context, 'home'),
          ),
        ),
        body: BlocProvider(
          create: (_) => _userBloc,
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                  ),
                );
              }
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return state.data['group_id'] == 5
                      ? _customer(state.data)
                      : _restaurant(state.data);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
  }

  Widget _customer(data) {
    final menuItem = [
      {
        'name': 'Informacion de la cuenta',
        'url': 'configurations',
        'icon': Icons.person
      },
      {
        'name': 'Cambiar contraseña',
        'url': 'chage_password',
        'icon': Icons.password
      },
    ];
    List<Widget> lista = <Widget>[];
    lista.add(clip);
    lista.add(infoProfile(data));
    lista.add(const Divider());
    for (var element in menuItem) {
      lista.add(ProfileMenuWidget(
          title: element['name'].toString(),
          icon: element['icon'] as IconData,
          onPress: () {
            Navigator.pushNamed(context, element['url'].toString());
          }));
    }
    lista.add(
      ProfileMenuWidget(
          title: "Salir",
          icon: Icons.logout,
          textColor: Colors.red,
          endIcon: false,
          onPress: () => closeSession(context)),
    );
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lista))));
  }

  Widget _restaurant(data) {
    final menuItem = [
      {
        'name': 'Informacion de la cuenta',
        'url': 'configurations',
        'icon': Icons.person
      },
      {
        'name': 'Cambiar contraseña',
        'url': 'chage_password',
        'icon': Icons.password
      },
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
    lista.add(clip);
    lista.add(infoProfile(data));
    lista.add(const Divider());
    for (var element in menuItem) {
      lista.add(ProfileMenuWidget(
          title: element['name'].toString(),
          icon: element['icon'] as IconData,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, element['url'].toString());
          }));
    }
    lista.add(
      ProfileMenuWidget(
          title: "Salir",
          icon: Icons.logout,
          textColor: Colors.red,
          endIcon: false,
          onPress: () => closeSession(context)),
    );
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lista))));
  }

  var clip = Stack(
    alignment: Alignment.center,
    children: [
      Image.asset(
        "assets/Black.jpg", // Reemplaza con la ruta de tu imagen de portada
        height: 200, // Ajusta la altura según tus necesidades
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Stack(children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/Profile.png"),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: Colors.blue),
            child: const Icon(
              Icons.edit_document,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ]),
    ],
  );

  Widget infoProfile(data) {
    return Center(
        child: Column(
      children: [
        const Text(
          "Informacion de Contacto",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "${data['nombre']} ${data['apellido_paterno']}",
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff323232),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data['username'],
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff323232),
          ),
        ),
      ],
    ));
  }
}
