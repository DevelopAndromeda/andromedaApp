import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/favorites/favorites_bloc.dart';

import 'package:andromeda/services/store.dart';

import 'package:andromeda/models/response.dart';
import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/witgets/not_session.dart';
import 'package:andromeda/witgets/no_search_result.dart';
import 'package:andromeda/witgets/time_slot_buttons.dart';
import 'package:andromeda/witgets/skeleton.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({super.key});

  @override
  State<MySavedPage> createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  final FavoriteBloc _newsBloc = FavoriteBloc();
  bool startAnimation = false;
  final DateTime _now = DateTime.now();

  @override
  void initState() {
    _newsBloc.add(GetFavoriteList());
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
          'Guardado',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: _body(),
    );
  }

  Container _body() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocListener<FavoriteBloc, FavoriteState>(
          listener: (context, state) {
            /*if (state is FavoriteError) {
              responseErrorWarning(context, state.message!);
            }*/
          },
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteInitial) {
                return const Skeleton(cantData: 4);
              } else if (state is FavoriteLoading) {
                return const Skeleton(cantData: 4);
              } else if (state is FavoriteLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    startAnimation = true;
                  });
                });
                return _buildCard(context, state.data);
              } /*else if (state is FavoriteError) {
                return const WrongConnection();
              } */
              else {
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
      if (model.data == null || model.data!['data'].isEmpty) {
        return const NoSearchResultFound();
      }

      if (model.data!['data'] == null) {
        return const WrongConnection();
      }

      if (model.data!['data'].runtimeType != List) {
        return const WrongConnection();
      }

      return ListView.builder(
        itemCount: model.data!['data'].length,
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red, // Cambia el color del icono aquí
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          _newsBloc.add(DeleteFavorite(
                              model.data!['data'][index]['product_id']));
                        },
                      ),
                    ),
                    // Imagen a la izquierda
                    Positioned(
                      left: 10,
                      top: 15,
                      bottom: 15,
                      child: InkWell(
                        onTap: () => goToRest(model.data!['data'][index]),
                        /*onTap: () => Navigator.pushNamed(context, 'detail',
                          arguments: model.data!['data'][index]['product']),*/
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
                        /*onTap: () => Navigator.pushNamed(context, 'detail',
                          arguments: model.data!['data'][index]['product']),*/
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
          );
        },
      );
    } else {
      if (model.data!['data'] == 'La info esta corrupta') {
        return const NoSearchResultFound();
      }
      return const WrongConnection();
    }
  }

  List<String> timeSlotFinal(model, index) {
    List<String> horas = [];
    if (model.data!['data'][index]['slots'] != null) {
      model.data!['data'][index]['slots'].forEach((index, element) {
        if (index.toString() == _now.weekday.toString()) {
          if (element[0]['slots_info'] == null) {
            horas.add(element[0]['from']);
          } else {
            if (!element[0]['slots_info'].isEmpty) {
              for (dynamic item in element[0]['slots_info']) {
                final HoraAcutal = item['time']
                    .replaceAll(" am", "")
                    .replaceAll(" pm", "")
                    .split(':');
                int hour = int.parse(HoraAcutal[0]);
                int minute = int.parse(HoraAcutal[1]);
                if (_now.hour == hour && _now.minute <= minute) {
                  horas.add(item['time']);
                }
              }
              return horas;
            } else {
              print('data is empty 2');
            }
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

  /*Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 4, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return const ListTile(
              title: Card(
            margin: EdgeInsets.all(5),
            elevation: 10,
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: SizedBox(width: 100, height: 90),
            ),
          ));
        },
      ),
    );
  }*/
}
