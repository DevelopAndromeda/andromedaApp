import 'package:andromeda/witgets/car_rest.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/witgets/skeleton.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/stores/store_bloc.dart';

import 'package:andromeda/witgets/Colores_Base.dart';
import 'package:andromeda/models/response.dart';
import 'package:andromeda/utilities/constanst.dart';
import 'package:andromeda/witgets/button_base.dart';

class ListRest extends StatefulWidget {
  const ListRest({super.key});

  @override
  State<ListRest> createState() => _ListRestState();
}

class _ListRestState extends State<ListRest> {
  //final StoreBloc _newsBloc = StoreBloc();
  bool startAnimation = false;

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
            'Retaurantes',
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
            if (state is StoreInitial || state is StoreLoading) {
              return const Skeleton(cantData: 4);
            } else if (state is StoreLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  startAnimation = true;
                });
              });
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
          return AnimatedContainer(
            margin: const EdgeInsets.all(8.0),
            duration: Duration(milliseconds: 300 + (index * 200)),
            transform: Matrix4.translationValues(
                startAnimation ? 0 : MediaQuery.of(context).size.width, 0, 0),
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
              button: baseButtom(
                onPressed: () {
                  Navigator.pushNamed(context, 'modification',
                      arguments: model.data!['items'][index]);
                },
                text: const Text(
                  'Modificación',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
}
