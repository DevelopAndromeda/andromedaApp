import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/reservations/reservation_bloc.dart';

import 'package:andromeda/witgets/colores_base.dart';
import 'package:andromeda/witgets/label_card.dart';
import 'package:andromeda/witgets/no_search_result.dart';
import 'package:andromeda/witgets/not_session.dart';

import 'package:andromeda/models/response.dart';

class ListReservacion extends StatefulWidget {
  const ListReservacion({super.key});

  @override
  State<ListReservacion> createState() => _ListReservacionState();
}

class _ListReservacionState extends State<ListReservacion> {
  final ReservationBloc _newsBloc = ReservationBloc();
  @override
  void initState() {
    _newsBloc.add(GetAllReservations());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Background_Color,
        appBar: AppBar(
          title: const Text(
            'Reservaciones',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                'profile', (Route<dynamic> route) => false),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<ReservationBloc, ReservationState>(
          listener: (context, state) {
            if (state is ReservationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<ReservationBloc, ReservationState>(
            builder: (context, state) {
              if (state is ReservationInitial) {
                return _buildLoading();
              } else if (state is ReservationLoading) {
                return _buildLoading();
              } else if (state is ReservationLoaded) {
                return _buildCard(context, state.data);
              } else if (state is ReservationError) {
                return Container();
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
          var data = model.data!['data'][index];
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Card(
              margin: const EdgeInsets.all(5),
              elevation: 10,
              child: SizedBox(
                width: 350,
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 110,
                      top: 10,
                      right: 65,
                      bottom: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cliente: ${data?['billing_firstname']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Estado: ${data!['status']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Hora: ${data?['product_options']!['info_buyRequest']!['booking_time'] ?? ''}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    LabelCard(
                        color: (model.data!['data'][index]['status'] ==
                                'complete'
                            ? const Color.fromARGB(255, 48, 20, 233)
                            : model.data!['data'][index]['status'] == 'pending'
                                ? const Color.fromARGB(255, 241, 206, 10)
                                : const Color.fromARGB(255, 235, 154, 148)),
                        title: model.data!['data'][index]['status'])
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Text('Ocurrio un error al obtener los datos'),
      );
    }
  }

  Widget _buildLoading() {
    return SizedBox(
      width: double.infinity,
      height: 100.0,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: const <Widget>[
                Card(
                  margin: EdgeInsets.all(5),
                  elevation: 10,
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: SizedBox(width: 100, height: 90),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
