import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/blocs/inicio/one/one_bloc.dart';
import 'package:appandromeda/blocs/inicio/second/second_bloc.dart';
import 'package:appandromeda/blocs/inicio/all/all_bloc.dart';
import 'package:appandromeda/blocs/inicio/user/user_bloc.dart';

import 'package:appandromeda/models/response.dart';
import 'package:appandromeda/utilities/constanst.dart';
import 'package:appandromeda/witgets/restaurant.dart';
import 'package:localstorage/localstorage.dart';

class MyStorePage extends StatefulWidget {
  const MyStorePage({super.key});

  @override
  _MyStorePageState createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  late final OneBloc _firstBloc;
  late final SecondBloc _secondBloc;
  late final AllBloc _allBloc;
  late final UserBloc _userBloc = UserBloc();
  String username = '';

  @override
  void initState() {
    super.initState();
    _firstBloc = OneBloc();
    _secondBloc = SecondBloc();
    _allBloc = AllBloc();

    _firstBloc.add(GetOneList());
    _secondBloc.add(GetSecondList());
    _allBloc.add(GetAllList());
    _userBloc.add(GetUser());

    //getUserData();
  }

  @override
  void dispose() {
    _firstBloc.close();
    _secondBloc.close();
    _allBloc.close();
    _userBloc.close();
    super.dispose();
  }

  /*fillFavorite(data) async {
    final allFavorites = await serviceDB.instance.queryRecord('favorites');

    for (int i = 0; i < data.length; i++) {
      data[i]['isFavorite'] = false;
      for (var toElement in allFavorites) {
        if (data[i]['id'] == toElement['id']) {
          data[i]['isFavorite'] = true;
          break;
        }
      }
    }

    return data;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BlocProvider(
                    create: (_) => _userBloc,
                    child: BlocListener<UserBloc, UserState>(
                      listener: (context, state) {
                        /*if (state is UserError) {
                          responseErrorWarning(context, state.message!);
                        }*/
                      },
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoaded) {
                            return _headerSesion(state);
                          } else {
                            return _header();
                          }
                        },
                      ),
                    ),
                  ),
                  //_header(),
                  const Text(
                    'Destacados',
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Exo Bold'),
                  ),
                  _firstSection(),
                  const Text(
                    'Mas Vistos',
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Exo Bold'),
                  ),
                  _secondSection(),
                  const Text(
                    'Todos los Restaurantes',
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Exo Bold'),
                  ),
                  _allRestaurants()
                ]),
          ),
        ),
      ),
    );
  }

  SizedBox _headerSesion(state) {
    final img = localStorage.getItem('img_profile');
    return SizedBox(
        child: Column(children: [
      const SizedBox(height: 30),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 2),
        title: Text("Buenas Tardes, ${state.data['nombre']}",
            style: const TextStyle(fontSize: 18, color: Colors.black)),
        trailing: CircleAvatar(
          radius: 50,
          /*minRadius: 20,
                        maxRadius: 50,*/
          backgroundImage: (img != "" && img != null)
              //? const AssetImage('assets/Masculino.jpg')
              ? whitAvatar(img.toString())
              : const AssetImage('assets/Masculino.jpg'),
          //  backgroundColor: Color.fromARGB(255, 8, 8, 8),
        ),
        onTap: () => Navigator.pushNamed(context, 'profile'),
      ),
      const SizedBox(height: 20)
    ]));
  }

  SizedBox _header() {
    return const SizedBox(
      child: Column(
        children: [
          /*SizedBox(height: 10),
          baseButtom(
            onPressed: () => Navigator.pushNamed(context, 'login'),
            text: const Text(
              "Iniciar Sesion",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),*/
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Padding _firstSection() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .38,
        child: BlocProvider(
          create: (_) => _firstBloc,
          child: BlocListener<OneBloc, OneState>(
            listener: (context, state) {
              if (state is OneError) {
                responseSuccessWarning(context, state.message!);
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
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .38,
        child: BlocProvider(
          create: (_) => _secondBloc,
          child: BlocListener<SecondBloc, SecondState>(
            listener: (context, state) {
              if (state is SecondError) {
                responseSuccessWarning(context, state.message!);
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
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .38,
        child: BlocProvider(
          create: (_) => _allBloc,
          child: BlocListener<AllBloc, AllState>(
            listener: (context, state) {
              if (state is AllError) {
                responseSuccessWarning(context, state.message!);
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
