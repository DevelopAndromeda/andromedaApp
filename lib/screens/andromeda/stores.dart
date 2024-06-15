import 'package:andromeda/blocs/inicio/user/user_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/inicio/one/one_bloc.dart';
import 'package:andromeda/blocs/inicio/second/second_bloc.dart';
import 'package:andromeda/blocs/inicio/all/all_bloc.dart';

import 'package:andromeda/models/response.dart';

import 'package:andromeda/components/restaurant.dart';

class MyStorePage extends StatefulWidget {
  const MyStorePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyStorePageState createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  final OneBloc _firstBloc = OneBloc();
  final SecondBloc _secondBloc = SecondBloc();
  final AllBloc _allBloc = AllBloc();
  final UserBloc _userBloc = UserBloc();
  String username = '';

  @override
  void initState() {
    _firstBloc.add(GetOneList());
    _secondBloc.add(GetSecondList());
    _allBloc.add(GetAllList());
    _userBloc.add(GetUser());
    super.initState();
    //getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  _header(),
                  const Text(
                    'Destacados',
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 18,
                        fontFamily: 'Exo Bold'),
                  ),
                  _firstSection(),
                  const Text(
                    'Mas Vistos',
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 18,
                        fontFamily: 'Exo Bold'),
                  ),
                  _secondSection(),
                  const Text(
                    'Todos los Restaurantes',
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 18,
                        fontFamily: 'Exo Bold'),
                  ),
                  _allRestaurants()
                ]))));
  }

  SizedBox _header() {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(height: 40),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 2),
            title: BlocProvider(
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
                      return Text("Buenas Tardes, ${state.data['nombre']}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black));
                    } else {
                      return const Text('Buenas Tardes, ',
                          style: TextStyle(fontSize: 18, color: Colors.black));
                    }
                  },
                ),
              ),
            ),
            trailing: const CircleAvatar(
              radius: 30,
              /*minRadius: 20,
                        maxRadius: 50,*/
              backgroundImage: AssetImage('assets/Masculino.jpg'),
              //  backgroundColor: Color.fromARGB(255, 8, 8, 8),
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'profile', (Route<dynamic> route) => false);
            },
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Padding _firstSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .3,
        child: BlocProvider(
          create: (_) => _firstBloc,
          child: BlocListener<OneBloc, OneState>(
            listener: (context, state) {
              if (state is OneError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                  ),
                );
              }
            },
            child: BlocBuilder<OneBloc, OneState>(
              builder: (context, state) {
                if (state is OneInitial) {
                  return _buildLoading();
                } else if (state is OneLoading) {
                  return _buildLoading();
                } else if (state is OneLoaded) {
                  return _buildCard(context, state.data);
                } else if (state is OneError) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding _secondSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .3,
        child: BlocProvider(
          create: (_) => _secondBloc,
          child: BlocListener<SecondBloc, SecondState>(
            listener: (context, state) {
              if (state is SecondError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                  ),
                );
              }
            },
            child: BlocBuilder<SecondBloc, SecondState>(
              builder: (context, state) {
                if (state is SecondInitial) {
                  return _buildLoading();
                } else if (state is SecondLoading) {
                  return _buildLoading();
                } else if (state is SecondLoaded) {
                  return _buildCard(context, state.data);
                } else if (state is SecondError) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding _allRestaurants() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .3,
        child: BlocProvider(
          create: (_) => _allBloc,
          child: BlocListener<AllBloc, AllState>(
            listener: (context, state) {
              if (state is AllError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                  ),
                );
              }
            },
            child: BlocBuilder<AllBloc, AllState>(
              builder: (context, state) {
                if (state is AllInitial) {
                  return _buildLoading();
                } else if (state is AllLoading) {
                  return _buildLoading();
                } else if (state is AllLoaded) {
                  return _buildCard(context, state.data);
                } else if (state is AllError) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Respuesta model) {
    if (model.result == 'ok') {
      if (model.data == null) {
        return const Center(
          child: Text('No Cuentas con una sesion'),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: model.data!['data']['items'].length,
        itemBuilder: (context, index) {
          if (model.data!['data']['items'][index]['images'] != null) {
            model.data!['data']['items'][index]['media_gallery_entries'] =
                model.data!['data']['items'][index]['images'];
          }
          return RestuarentScreen(data: model.data!['data']['items'][index]);
        },
      );
    } else {
      return const Center(
        child: Text('Ocurrio un error al obtener los datos'),
      );
    }
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
