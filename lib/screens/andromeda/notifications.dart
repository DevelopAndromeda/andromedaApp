import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/notificaciones/notificaciones_bloc.dart';

import 'package:andromeda/models/response.dart';

import 'package:andromeda/witgets/reservation_notificacion.dart';
import 'package:andromeda/witgets/not_session.dart';
import 'package:andromeda/witgets/no_search_result.dart';

import 'package:andromeda/witgets/skeleton.dart';

class MyNotificationsPage extends StatefulWidget {
  const MyNotificationsPage({super.key});

  @override
  State<MyNotificationsPage> createState() => _MyNotificationsPageState();
}

class _MyNotificationsPageState extends State<MyNotificationsPage> {
  final NotificacionesBloc _newsBloc = NotificacionesBloc();

  @override
  void initState() {
    _newsBloc.add(GetNotificacionesList());
    super.initState();
  }

  @override
  void dispose() {
    _newsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notificaciones',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        body:
            _body() /*Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: ReservationNotification(
            title: "Confirmacion de tu reservación",
            subtitle: "Nombre del Restaurante",
            description: "Datos de la reservación",
            imagePath: "assets/Login.png",
            onClose: () {
              //print("Notificaciones");
            },
          ),
        ),
      ),*/
        );
  }

  Container _body() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<NotificacionesBloc, NotificacionesState>(
          listener: (context, state) {
            /*if (state is FavoriteError) {
              responseErrorWarning(context, state.message!);
            }*/
          },
          child: BlocBuilder<NotificacionesBloc, NotificacionesState>(
            builder: (context, state) {
              if (state is NotificacionesInitial) {
                return const Skeleton(cantData: 4);
              } else if (state is NotificacionesLoading) {
                return const Skeleton(cantData: 4);
              } else if (state is NotificacionesLoaded) {
                return _buildCard(context, state.data);
              } else if (state is NotificacionesError) {
                return const WrongConnection();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Respuesta model) {
    if (model.result == 'ok') {
      if (model.data!['data'] == null) {
        return const WrongConnection();
      }

      if (model.data == null || model.data!['data'].isEmpty) {
        return const NoSearchResultFound();
      }

      return ListView.builder(
          itemCount: model.data!['data'].length,
          itemBuilder: (context, index) {
            return ReservationNotification(
              title: model.data!['data'][index]['message'],
              subtitle: "Nombre del Restaurante",
              description: "Datos de la reservación",
              imagePath: model.data!['data'][index]['image'] ?? "",
              onClose: () {
                //print("Notificaciones");
              },
            );
          });
    } else {
      return const NoSearchResultFound();
    }
  }
}
