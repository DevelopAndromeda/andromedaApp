import 'package:andromeda/witgets/time_slot_buttons.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/history/history_bloc.dart';

import 'package:andromeda/witgets/label_card.dart';
import 'package:andromeda/witgets/no_search_result.dart';
import 'package:andromeda/witgets/not_session.dart';
import 'package:andromeda/witgets/skeleton.dart';

import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/models/response.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({super.key});

  @override
  State<MyHistoryPage> createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  final HistoryBloc _newsBloc = HistoryBloc();

  @override
  void initState() {
    _newsBloc.add(GetHistoryList());
    //_userBloc.add(GetUser());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Historial',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<HistoryBloc, HistoryState>(
          listener: (context, state) {
            /*if (state is HistoryError) {
              responseErrorWarning(context, state.message!);
            }*/

            if (state is HistoryLoaded) {
              if (state.data.result == 'ok') {
                if (state.data.data != null &&
                    state.data.data!['items'].isNotEmpty) {
                  //print(state.data.data!['items'][0]);
                  responseSuccessWarning(context,
                      "Te recordamos que peudes realizar una reseña a tu ultima visita en ${state.data.data!['items'][0]['items'][0]['name']}");
                  //infoAlertModal(context,
                  //    "Te recordamos que peudes realizar una reseña a tu ultima visita en ${state.data.data!['items'][0]['items'][0]['name']}");
                  return;
                }
              }
            }
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryInitial) {
                return const Skeleton(cantData: 4);
              } else if (state is HistoryLoading) {
                return const Skeleton(cantData: 4);
              } else if (state is HistoryLoaded) {
                return _buildCard(context, state.data);
              } else if (state is HistoryError) {
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
      if (model.data == null) {
        return const WrongConnection();
      }

      if (model.data!['items'].isEmpty) {
        return const NoSearchResultFound();
      }

      //infoAlertModal(context,
      //    "Te recordamos que peudes realizar una reseña a tu ultima visita en ${model.data!['items'][0]['items'][0]['name']}");

      return ListView.builder(
          itemCount: model.data!['total_count'],
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(5),
              elevation: 10,
              child: SizedBox(
                width: 350,
                height: 200,
                child: Stack(
                  children: <Widget>[
                    // Imagen a la izquierda
                    Positioned(
                      left: 10,
                      top: 15,
                      bottom: 15,
                      child: Container(
                          width: 120,
                          height: 90,
                          decoration: getImg(model.data!['items'][index]
                                      ['items'][0]['extension_attributes'] !=
                                  null
                              ? model.data!['items'][index]['items'][0]
                                  ['extension_attributes']['image'][0]
                              : null)),
                    ),
                    Positioned(
                      left: 140,
                      top: 10,
                      right: 65,
                      bottom: 5,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, 'detail',
                            arguments: model.data!['items'][index]['items'][0]
                                ['product_id']),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.data!['items'][index]['items'][0]['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    r"$$$$",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  RatingBarIndicator(
                                    rating: 0.0,
                                    //rating: 0.0,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 20, 20, 20),
                                    ),
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const Text(
                                    //"${getCustomAttribute(widget.data['custom_attributes'], 'product_score')}",
                                    "0",
                                    style: TextStyle(
                                        color: Color(0xff323232),
                                        fontSize: 12,
                                        fontFamily: 'Exo Light'),
                                  ),
                                  const Text(
                                    //"${getCustomAttribute(widget.data['custom_attributes'], 'product_score')}",
                                    " reseñas",
                                    style: TextStyle(
                                        color: Color(0xff323232),
                                        fontSize: 12,
                                        fontFamily: 'Exo Light'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "",
                                style: TextStyle(
                                    color: Color(0xff323232),
                                    fontSize: 12,
                                    fontFamily: 'Exo Light'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Botones de Modificar y Eliminar en la parte inferior derecha
                    Align(
                      alignment: Alignment.bottomRight,
                      child: model.data!['items'][index]['status'] != 'canceled'
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors
                                        .red, // C/ Cambia el color del icono aquí
                                  ),
                                  iconSize: 22,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Eliminar Reservación'),
                                          content: const Text(
                                              '¿Estás seguro de que quieres cancelar esta reservación?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(
                                                      false), // No eliminar, cerrar diálogo
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop(true);
                                                _newsBloc.add(ChangeStatusHistory(
                                                    '${model.data!['items'][index]['items'][0]['order_id']}',
                                                    'cancel'));
                                              },
                                              child: const Text(
                                                'Sí',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {});
                                        responseSuccessWarning(context,
                                            'Se Cancelo tu reservacion');
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    /*const Positioned(
                        left: 133,
                        bottom: 33,
                        child: TimeSlotButton(
                            anchoButton: 10, altoButton: 35, sizeText: 13)),*/
                    //Etiqueta de estado
                    LabelCard(
                        color: (model.data!['items'][index]['status'] ==
                                'complete'
                            ? const Color.fromARGB(255, 46, 17, 238)
                            : model.data!['items'][index]['status'] == 'pending'
                                ? const Color.fromARGB(255, 207, 176, 2)
                                : const Color.fromARGB(255, 241, 58, 45)),
                        title: translateStatus(
                            model.data!['items'][index]['status']))
                  ],
                ),
              ),
            );
          });
    } else {
      return const NoSearchResultFound();
    }
  }

  BoxDecoration getImg(String? img) {
    if (img != null) {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
              image: NetworkImage(pathMedia(img)), fit: BoxFit.cover));
    } else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: const DecorationImage(
            image: AssetImage('assets/notFoundImg.png'),
            fit: BoxFit.cover,
          ));
    }
  }
}
