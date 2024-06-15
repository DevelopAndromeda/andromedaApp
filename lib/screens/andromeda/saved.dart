import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:andromeda/services/store.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/favorites/favorites_bloc.dart';

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
            if (state is FavoriteError) {
              responseErrorWarning(context, state.message!);
            }
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
                responseErrorWarning(context, state.message!);
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
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: getImg(
                          model.data!['data'][index]['images'] != null
                              ? model.data!['data'][index]['images'][0]['file']
                              : null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors
                                    .red, // Cambia el color del icono aquí
                              ),
                              onPressed: () async {
                                _newsBloc.add(DeleteFavorite(
                                    model.data!['data'][index]['product_id']));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      model.data!['data'][index]['name'],
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'SKU: ${model.data!['data'][index]['sku']}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
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
                              .getById(model.data!['data'][index]['product_id'])
                              .then((value) {
                            if (value.result == 'ok') {
                              if (value.data!['data']['items'] != null) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'detail',
                                    arguments: value.data!['data']['items'][0],
                                    (Route<dynamic> route) => false);
                              }
                            }
                          });
                        },
                        child: const Text('Ir al detalle',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
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
