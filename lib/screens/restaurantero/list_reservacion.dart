import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/blocs/reservations/reservation_bloc.dart';

import 'package:appandromeda/witgets/colores_base.dart';
import 'package:appandromeda/witgets/label_card.dart';
//import 'package:appandromeda/witgets/screens/no_search_result_1.dart';
import 'package:appandromeda/witgets/screens/screen_widget_export.dart';

import 'package:appandromeda/services/catalog.dart';

import 'package:appandromeda/models/status.dart';
import 'package:appandromeda/models/response.dart';
import 'package:appandromeda/utilities/constanst.dart';

class ListReservacion extends StatefulWidget {
  const ListReservacion({super.key});

  @override
  State<ListReservacion> createState() => _ListReservacionState();
}

class _ListReservacionState extends State<ListReservacion> {
  //final ReservationBloc _newsBloc = ReservationBloc();
  final CatalogService _catalogService = CatalogService();
  final List<String> list = <String>[
    'Pendiente',
    'Reservada',
    'Por atender',
    'Atendido',
    'Cancelado'
  ];
  late Future<List<Status>>? futureStatus;

  get label => null;

  @override
  void initState() {
    //_newsBloc.add(GetAllReservations());
    futureStatus = _catalogService.fetchStatus();
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
            onPressed: () => Navigator.pushNamed(context, 'profile'),
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
        create: (_) => ReservationBloc()..add(GetAllReservations()),
        child: BlocBuilder<ReservationBloc, ReservationState>(
          builder: (context, state) {
            if (state is ReservationInitial) {
              return _buildLoading();
            } else if (state is ReservationLoading) {
              return _buildLoading();
            } else if (state is ReservationErrorSession) {
              return const WrongConnection();
            } else if (state is ReservationLoaded) {
              return _buildCard(context, state.data);
            } else if (state is ReservationLoadedEmpty) {
              return NotSearchResults(img: "Historial_Restaurantero.png");
            } else if (state is ReservationError) {
              return WrongConnection();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Respuesta model) {
    return ListView.builder(
      itemCount: model.data?['data']?.length ?? 0,
      itemBuilder: (context, index) {
        var data = model.data!['data'][index];
        data?['product_options']!['info_buyRequest']!['booking_time'] =
            "${data?['product_options']!['info_buyRequest']!['booking_time']}"
                .trim();
        return Card(
          margin: const EdgeInsets.all(5),
          elevation: 10,
          child: InkWell(
            onTap: () {
              if (model.data!['data'][index]['status'] != 'canceled') {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            const Text('Seleccione Estado'),
                            const SizedBox(height: 20),
                            Expanded(
                              child: FutureBuilder<List<Status>>(
                                future: futureStatus,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownMenu<Status>(
                                        onSelected: (Status? value) {
                                          if (value!.value == 'canceled') {
                                            closeReservation(context,
                                                data['entity_id'], value.label);
                                          } else {
                                            Navigator.pop(context);
                                            ReservationBloc()
                                              ..add(ChangeStatusReservation(
                                                  data['entity_id'],
                                                  value.label));
                                          }
                                        },
                                        dropdownMenuEntries: snapshot.data!
                                            .map<DropdownMenuEntry<Status>>(
                                                (Status value) {
                                          return DropdownMenuEntry<Status>(
                                              value: value, label: value.label);
                                        }).toList());
                                  } else if (snapshot.hasError) {
                                    return Text("${snapshot.error}");
                                  }
                                  return const SizedBox(
                                    height: 50,
                                    child: Text('Seleccione Pais'),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
            child: SizedBox(
              width: 350,
              height: 130,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 130,
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
                          const SizedBox(height: 10),
                          Text(
                            'Estado: ${data!['status']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Hora: ${data?['product_options']!['info_buyRequest']!['booking_time']}'
                                .trim(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  LabelCard(
                      color:
                          transformColor(model.data!['data'][index]['status']),
                      title:
                          translateStatus(model.data!['data'][index]['status']))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      width: double.infinity,
      height: 100.0,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
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