import 'dart:io';

import 'package:andromeda/blocs/user/user_sesion_bloc.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

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
  File? imgProfile;

  @override
  void initState() {
    _userBloc.add(GetUser());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    context
        .read<UserSesionLogic>()
        .updateImgLogic(File(returnImage.path), context);
    Navigator.of(context).pop(); //close the model sheet
  }

  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    context
        .read<UserSesionLogic>()
        .updateImgLogic(File(returnImage.path), context);

    Navigator.of(context).pop();
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
          color: Colors.white,
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
      ),
    );
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
        'url': 'change-password',
        'icon': Icons.password
      },
    ];
    List<Widget> lista = <Widget>[];
    lista.add(clip(data));
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
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: lista),
      ),
    );
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
        'url': 'change-password',
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
      }
    ];
    List<Widget> lista = <Widget>[];
    lista.add(clip(data));
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
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: lista),
      ),
    );
  }

  Widget clip(data) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/Black.jpg", // Reemplaza con la ruta de tu imagen de portada
          height: 200, // Ajusta la altura según tus necesidades
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Stack(children: [
          CircleAvatar(
              radius: 50,
              backgroundImage:
                  (data['img_profile'] != null && data['img_profile'] != "")
                      ? const AssetImage('assets/Masculino.jpg')
                      //? whitAvatar(data['img_profile'])
                      : const AssetImage('assets/Masculino.jpg')),
          Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () => showImagePickerOption(context),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue),
                  child: const Icon(
                    Icons.edit_document,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              )),
        ]),
      ],
    );
  }

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

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.blue[100],
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void deleteImage() async {
    setState(() {
      imgProfile = null;
    });
  }
}
