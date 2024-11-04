import 'package:appandromeda/witgets/car_rest.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/blocs/stores/store_bloc.dart';

import 'package:appandromeda/models/response.dart';

import 'package:appandromeda/utilities/constanst.dart';
import '../../witgets/boton_base.dart';
import 'package:appandromeda/witgets/Colores_Base.dart';

class ListReview extends StatefulWidget {
  const ListReview({super.key});

  @override
  State<ListReview> createState() => _ListReviewState();
}

class _ListReviewState extends State<ListReview> {
  //final StoreBloc _newsBloc = StoreBloc();

  @override
  void initState() {
    //_newsBloc.add(GetStoresList());
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
            'Comentarios',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            onPressed: () => Navigator.pushNamed(context, 'profile'),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => StoreBloc()..add(GetStoresList()),
        child: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state is StoreInitial) {
              return _buildLoading();
            } else if (state is StoreLoading) {
              return _buildLoading();
            } else if (state is StoreLoaded) {
              return _buildCard(context, state.data);
            } else if (state is StoreError) {
              return Container();
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
        return const Center(
          child: Text('No encontramos resultados'),
        );
      }
      if (model.data!['items'] == null) {
        return const Center(
          child: Text('No encontramos resultados'),
        );
      }
      return ListView.builder(
        itemCount: model.data!['items'].length,
        itemBuilder: (context, index) {
          return Container(
              margin: const EdgeInsets.all(8.0),
              child: CardRest(
                texto: model.data!['items'][index]['name'],
                img: model.data!['items'][index]['media_gallery_entries'] !=
                            null &&
                        model.data!['items'][index]['media_gallery_entries']
                            .isNotEmpty
                    ? Image.network(
                        pathMedia(model.data!['items'][index]
                            ['media_gallery_entries'][0]['file']),
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/notFoundImg.png',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                button: MyBaseButtom(
                  onPressed: () {
                    Navigator.pushNamed(context, 'reviews',
                        arguments: model.data!['items'][index]);
                  },
                  text: const Text(
                    'Ver Comentarios',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ));
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
