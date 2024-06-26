import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/history/history_bloc.dart';
import 'package:andromeda/blocs/inicio/user/user_bloc.dart';

import 'package:andromeda/witgets/label_card.dart';
import 'package:andromeda/witgets/no_search_result.dart';
import 'package:andromeda/witgets/not_session.dart';

import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/models/response.dart';

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({Key? key}) : super(key: key);

  @override
  State<MyHistoryPage> createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  final HistoryBloc _newsBloc = HistoryBloc();
  final UserBloc _userBloc = UserBloc();

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
                /*if (model.data == null) {
                return const WrongConnection();
              }*/

                if (state.data.data != null &&
                    state.data.data!['items'].isNotEmpty) {
                  print(state.data.data!['items'][0]);
                  infoAlertModal(context,
                      "Te recordamos que peudes realizar una reseña a tu ultima visita en ${state.data.data!['items'][0]['items'][0]['name']}");
                }
              }
            }
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryInitial) {
                return _buildLoading();
              } else if (state is HistoryLoading) {
                return _buildLoading();
              } else if (state is HistoryLoaded) {
                return _buildCard(context, state.data);
              } else if (state is HistoryError) {
                //responseErrorWarning(context, state.message!);
                return const WrongConnection();
                //return Container();
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

      return ListView.builder(
          itemCount: model.data!['total_count'],
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(5),
              elevation: 10,
              child: SizedBox(
                width: 350,
                height: 150,
                child: Stack(
                  children: <Widget>[
                    // Imagen a la izquierda
                    Positioned(
                      left: 10,
                      top: 15,
                      bottom: 15,
                      child: Container(
                          width: 100,
                          height: 90,
                          decoration: getImg(model.data!['items'][index]
                                      ['items'][0]['extension_attributes'] !=
                                  null
                              ? model.data!['items'][index]['items'][0]
                                  ['extension_attributes']['image'][0]
                              : null)),
                    ),

                    // Título, descripción y número de personas a la derecha
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
                              model.data!['items'][index]['items'][0]['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Estado: ${model.data!['items'][index]['status']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            /*Text(
                                  'Fecha: ${DateFormat('dd/MM/yyyy').format(dateTimeWithTimeZone)}',
                                  style: const TextStyle(fontSize: 14),
                                ),*/
                            const SizedBox(height: 10),
                            const Text(
                              'Cantidad de Personas: 0',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Botones de Modificar y Eliminar en la parte inferior derecha
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                            ),
                            // Espacio entre los botones
                            model.data!['items'][index]['status'] != 'canceled'
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(255, 8, 8,
                                              8), // Cambia el color del icono aquí
                                        ),
                                        iconSize: 16,
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
                                                    onPressed: () => Navigator
                                                            .of(context)
                                                        .pop(
                                                            false), // No eliminar, cerrar diálogo
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                      _newsBloc.add(
                                                          ChangeStatusHistory(
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
                          ],
                        ),
                      ),
                    ),

                    //Etiqueta de estado
                    LabelCard(
                        color: (model.data!['items'][index]['status'] ==
                                'complete'
                            ? const Color.fromARGB(255, 48, 20, 233)
                            : model.data!['items'][index]['status'] == 'pending'
                                ? const Color.fromARGB(255, 241, 206, 10)
                                : const Color.fromARGB(255, 235, 154, 148)),
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
                )
              ],
            ),
          )),
    );
  }
}
