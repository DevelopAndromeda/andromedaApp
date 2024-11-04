import 'package:appandromeda/witgets/screens/screen_widget_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/blocs/favorites/favorites_bloc.dart';

import 'package:appandromeda/services/store.dart';

import 'package:appandromeda/models/response.dart';
import 'package:appandromeda/utilities/constanst.dart';

//import 'package:appandromeda/witgets/screens/no_search_result_1.dart';
import 'package:appandromeda/witgets/time_slot_buttons.dart';
import 'package:appandromeda/witgets/skeleton.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({super.key});

  @override
  State<MySavedPage> createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  bool startAnimation = false;
  final DateTime _now = DateTime.now();
  late FavoriteBloc _favoriteBloc;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = FavoriteBloc()..add(GetFavoriteList());
  }

  @override
  void dispose() {
    _favoriteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guardado',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: BlocProvider<FavoriteBloc>.value(
        value: _favoriteBloc,
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteInitial) {
              return const Skeleton(cantData: 4);
            } else if (state is FavoriteLoading) {
              return const Skeleton(cantData: 4);
            } else if (state is FavoriteErrorSession) {
              return const WrongConnection();
            } else if (state is FavoriteLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  startAnimation = true;
                });
              });
              return _buildCard(context, state.data);
            } else if (state is FavoriteLoadedEmpty) {
              return NotSearchResults(img: "Favoritos_Customer.png");
            } else if (state is FavoriteError) {
              return const WrongConnection();
            } else {
              return Container();
            }

            /* else if (state is FavoriteError) {
                return const NoSearchResultFound();
              }*/
            /*else {
              return Container();
            }*/
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Respuesta model) {
    return ListView.builder(
      itemCount: model.data!['data'].length,
      itemBuilder: (context, index) {
        final item = model.data!['data'][index]['product_id'];
        return Dismissible(
          key: Key(item),
          onDismissed: (direction) {
            _favoriteBloc
                .add(DeleteFavorite(model.data!['data'][index]['product_id']));
            setState(() {
              model.data!['data'].removeAt(index);
            });

            // Then show a snackbar.
            responseSuccessWarning(context, "Registro Borrado");
          },
          child: AnimatedContainer(
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
                    // Imagen a la izquierda
                    Positioned(
                      left: 10,
                      top: 15,
                      bottom: 15,
                      child: InkWell(
                        onTap: () => goToRest(model.data!['data'][index]),
                        child: Container(
                          width: 120,
                          height: 90,
                          decoration: getImg(
                              model.data!['data'][index]['images'] != null
                                  ? model.data!['data'][index]['images'][0]
                                      ['file']
                                  : null),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      top: 10,
                      right: 65,
                      bottom: 5,
                      child: InkWell(
                        onTap: () => goToRest(model.data!['data'][index]),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.data!['data'][index]['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    transformPrice(model.data!['data'][index]
                                            ['price']
                                        .toString()),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  RatingBarIndicator(
                                    rating: double.parse(model.data!['data']
                                                [index]['product']
                                            ['product_score'] ??
                                        "0.0"),
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
                              Text(
                                "${model.data!['data'][index]['product']['category_string'] ?? ''}",
                                style: const TextStyle(
                                    color: Color(0xff323232),
                                    fontSize: 12,
                                    fontFamily: 'Exo Light'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 133,
                        bottom: 33,
                        child: TimeSlotButton(
                            anchoButton: 10,
                            altoButton: 30,
                            sizeText: 10,
                            horas: timeSlotFinal(model, index),
                            data: model.data!['data'][index])),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /*List<String> timeSlotFinal(model, index) {
    if (model.data!['data'][index]['slots'] == null) {
      return [];
    }

    return obtenerHorasValidas(model.data!['data'][index]['slots']);
  }*/

  List<String> timeSlotFinal(model, index) {
    List<String> horas = [];
    //print(model.data!['data'][index]['slots']);
    if (model.data!['data'][index]['slots'] != null) {
      //print('*********TimeSlot*************');
      //print(model.data!['data'][index]['slots']);
      model.data!['data'][index]['slots'].forEach((index, element) {
        if (index.toString() == _now.weekday.toString()) {
          if (element[0]['slots_info'] == null) {
            horas.add(element[0]['from']);
          } else {
            if (!element[0]['slots_info'].isEmpty) {
              for (dynamic item in element[0]['slots_info']) {
                /*final HoraAcutal = item['time']
                    .replaceAll(" am", "")
                    .replaceAll(" pm", "")
                    .split(':');*/
                //int hour = int.parse(HoraAcutal[0]);
                //int minute = int.parse(HoraAcutal[1]);
                /*print(_now.hour);
                print(hour);
                print(_now.minute);
                print(minute);
                print((_now.hour == hour || _now.hour == (hour + 12)) &&
                    _now.minute <= minute);
                if ((_now.hour == hour || _now.hour == (hour + 12)) &&
                    _now.minute <= minute) {
                  horas.add(item['time']);
                }*/
                horas.add(item['time']);
              }
              return horas;
            } /*else {
              print('data is empty 2');
            }*/
          }
        }
      });
    }
    return horas;
  }

  void goToRest(data) async {
    //model.data!['data'][index]
    StoreService service = StoreService();
    await service.getById(data['product_id']).then((value) {
      if (value.result == 'ok') {
        if (value.data!['data']['items'] != null) {
          Navigator.pushNamed(context, 'detail',
              arguments: value.data!['data']['items'][0]);
        }
      }
    });
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
