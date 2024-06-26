import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/favorites/favorites_bloc.dart';

import 'package:andromeda/services/store.dart';

import 'package:andromeda/models/response.dart';
import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/witgets/not_session.dart';
import 'package:andromeda/witgets/no_search_result.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({super.key});

  @override
  State<MySavedPage> createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  final FavoriteBloc _newsBloc = FavoriteBloc();

  @override
  void initState() {
    _newsBloc.add(GetFavoriteList());
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
                return _buildLoading();
              } else if (state is FavoriteLoading) {
                return _buildLoading();
              } else if (state is FavoriteLoaded) {
                return _buildCard(context, state.data);
              } else if (state is FavoriteError) {
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
    print(model);
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
          return Card(
            margin: const EdgeInsets.all(5),
            elevation: 10,
            child: SizedBox(
              width: 350,
              height: 170,
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
                              const SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    r"$$$$",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  RatingBarIndicator(
                                    /*rating: double.parse(getCustomAttribute(
                                        widget.data['custom_attributes'],
                                        'product_score')
                                    .toString()),*/
                                    rating: double.parse("0.0"),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 20, 20, 20),
                                    ),
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    direction: Axis.horizontal,
                                  ),
                                  Text(
                                    //"${getCustomAttribute(widget.data['custom_attributes'], 'product_score')}",
                                    "0",
                                    style: const TextStyle(
                                        color: Color(0xff323232),
                                        fontSize: 12,
                                        fontFamily: 'Exo Light'),
                                  ),
                                  Text(
                                    //"${getCustomAttribute(widget.data['custom_attributes'], 'product_score')}",
                                    " reseñas",
                                    style: const TextStyle(
                                        color: Color(0xff323232),
                                        fontSize: 12,
                                        fontFamily: 'Exo Light'),
                                  ),
                                  /*Text(
                        "( 0 )",
                        style: TextStyle(
                            color: Color(0xffa9a9a9),
                            fontSize: 12,
                            fontFamily: 'Exo Bold'),
                      ),*/
                                ],
                              ),
                              /*const SizedBox(height: 10),
                          const Text(
                            'Cantidad de Personas: 0',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),*/
                              const SizedBox(height: 10),
                              Text(
                                //"${getCustomAttribute(widget.data['custom_attributes'], 'product_score')}",
                                "Tipo de comida",
                                style: const TextStyle(
                                    color: Color(0xff323232),
                                    fontSize: 12,
                                    fontFamily: 'Exo Light'),
                              ),
                              /*const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity, // Ajusta el ancho deseado
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () async {
                                StoreService service = StoreService();
                                await service
                                    .getById(model.data!['data'][index]
                                        ['product_id'])
                                    .then((value) {
                                  if (value.result == 'ok') {
                                    if (value.data!['data']['items'] != null) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              'detail',
                                              arguments: value.data!['data']
                                                  ['items'][0],
                                              (Route<dynamic> route) => false);
                                    }
                                  }
                                });
                              },
                              child: const Text('Ir al detalle',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),*/
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const WrongConnection();
    }
  }

  void goToRest(data) async {
    //model.data!['data'][index]
    StoreService service = StoreService();
    await service.getById(data['product_id']).then((value) {
      if (value.result == 'ok') {
        if (value.data!['data']['items'] != null) {
          Navigator.pushNamed(context, 'detail',
              arguments: value.data!['data']['items'][0]);
          /*Navigator.of(context).pushNamedAndRemoveUntil(
              'detail',
              arguments: value.data!['data']['items'][0],
              (Route<dynamic> route) => false);*/
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
              children: const [
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
