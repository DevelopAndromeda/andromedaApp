import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/blocs/notificaciones/notificaciones_bloc.dart';

import 'package:appandromeda/models/response.dart';

import 'package:appandromeda/witgets/reservation_notificacion.dart';
import 'package:appandromeda/witgets/screens/screen_widget_export.dart';
//import 'package:appandromeda/witgets/screens/no_search_result_1.dart';

import 'package:appandromeda/witgets/skeleton.dart';

class MyNotificationsPage extends StatefulWidget {
  const MyNotificationsPage({super.key});

  @override
  State<MyNotificationsPage> createState() => _MyNotificationsPageState();
}

class _MyNotificationsPageState extends State<MyNotificationsPage> {
  late final NotificacionesBloc _notificacionBloc;

  @override
  void initState() {
    super.initState();
    _notificacionBloc = NotificacionesBloc();
    _notificacionBloc.add(GetNotificacionesList());
  }

  @override
  void dispose() {
    _notificacionBloc.close();
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
        create: (_) => _notificacionBloc,
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
              } else if (state is NotificacionesErrorSession) {
                return const WrongConnection();
              } else if (state is NotificacionesLoaded) {
                return _buildCard(context, state.data);
              } else if (state is NotificacionesLoadedEmpty) {
                return NotSearchResults(img: "Notificaciones.png");
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
    return ListView.builder(
        itemCount: model.data!['data'].length,
        itemBuilder: (context, index) {
          return ReservationNotification(
            title: model.data!['data'][index]['message'],
            subtitle: model.data!['data'][index]['product_name'] ?? "",
            description: model.data!['data'][index]['created_at'] ?? "",
            imagePath: model.data!['data'][index]['image'] ?? "",
            onClose: () {
              //print("Notificaciones");
            },
          );
        });
  }
}
