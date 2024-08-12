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
  bool startAnimation = false;
  late HistoryBloc _historyBloc; // Usamos late para inicializar en initState

  @override
  void initState() {
    super.initState();
    _historyBloc = HistoryBloc()..add(GetHistoryList());
  }

  @override
  void dispose() {
    _historyBloc.close();
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
      body: BlocProvider<HistoryBloc>.value(
        value: _historyBloc,
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryInitial || state is HistoryLoading) {
              return const Skeleton(cantData: 4);
            } else if (state is HistoryLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  startAnimation = true;
                });

                /*print(1);

                Fluttertoast.showToast(
                    msg:
                        "Te recordamos que peudes realizar una reseña a tu ultima visita en ${state.data.data!['items'][0]['items'][0]['name']}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green[400],
                    textColor: Colors.white,
                    fontSize: 16.0);*/
              });
              return _buildCard(context, state.data);
            } else if (state is HistoryError) {
              return const WrongConnection();
            } else {
              return Container();
            }
          },
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
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 200)),
            transform: Matrix4.translationValues(
                startAnimation ? 0 : MediaQuery.of(context).size.width, 0, 0),
            child: Card(
              margin: const EdgeInsets.all(5),
              elevation: 10,
              child: SizedBox(
                width: 350,
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 10,
                      top: 15,
                      bottom: 15,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, 'orden',
                            arguments: model.data!['items'][index]
                                ['entity_id']),
                        child: Container(
                          width: 120,
                          height: 90,
                          decoration: getImg(model.data!['items'][index]
                                  ['items'][0]['extension_attributes']?['image']
                              [0]),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      top: 10,
                      right: 65,
                      bottom: 5,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, 'orden',
                            arguments: model.data!['items'][index]
                                ['entity_id']),
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
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 20, 20, 20),
                                    ),
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const Text(
                                    "0",
                                    style: TextStyle(
                                        color: Color(0xff323232),
                                        fontSize: 12,
                                        fontFamily: 'Exo Light'),
                                  ),
                                  const Text(
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: model.data!['items'][index]['status'] !=
                                  'canceled' &&
                              model.data!['items'][index]['status'] != 'cancel'
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
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
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('No',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop(true);
                                                _historyBloc.add(
                                                    ChangeStatusHistory(
                                                        '${model.data!['items'][index]['items'][0]['order_id']}',
                                                        'cancel'));
                                                await Future.delayed(
                                                    const Duration(seconds: 2));
                                                _historyBloc
                                                    .add(GetHistoryList());
                                                // Al hacer clic en "Sí", el evento se envía al mismo BLoC.
                                                /*HistoryBloc()
                                                  ..add(ChangeStatusHistory(
                                                      '${model.data!['items'][index]['items'][0]['order_id']}',
                                                      'cancel'));
                                                HistoryBloc()
                                                  ..add(GetHistoryList());*/
                                              },
                                              child: const Text('Sí',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ],
                                        );
                                      },
                                    ).then((value) {
                                      if (value == true) {
                                        responseSuccessWarning(context,
                                            'Se canceló tu reservación');
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    LabelCard(
                        color: transformColor(
                            model.data!['items'][index]['status']),
                        title: translateStatus(
                            model.data!['items'][index]['status'])),
                  ],
                ),
              ),
            ),
          );
        },
      );
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
