import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/inicio/one/one_bloc.dart';

import 'package:andromeda/models/response.dart';
import 'package:andromeda/witgets/time_slot_buttons.dart';
import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/services/store.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  final DateTime _now = DateTime.now();
  final search = TextEditingController();

  late final OneBloc _firstBloc;
  final StoreService _storeService = StoreService();

  @override
  void initState() {
    super.initState();
    _firstBloc = OneBloc();
    _firstBloc.add(GetOneList());
  }

  @override
  void dispose() {
    _firstBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 154, 126, 43),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                      //controller: search,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      placeholder: "Buscar",
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.search,
                          color: Color(0xff7b7b7b),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: const Color(0xfff7f7f7),
                          borderRadius: BorderRadius.circular(10)),
                      style: const TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontFamily: 'Exo Regular'),
                      onChanged: (value) async {
                        setState(() {
                          search.text = value;
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: (search.text.length >= 3)
          ? SingleChildScrollView(
              child: FutureBuilder(
                  future: _storeService.getRestaurantsSearch(search.text),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Column(
                      children:
                          _createList(snapshot.data.data['data']!['items']),
                    );
                  },
                  initialData: const []),
            )
          : Column(
              children: [
                preSlider(),
                const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centra verticalmente
                    children: [
                      Text('Ingresa datos para realizar una busqueda'),
                      SizedBox(height: 10), // Espacio entre los textos
                      Text('Nombre de restaurante'),
                      SizedBox(height: 10),
                      Text('Ciudad'),
                      SizedBox(height: 10),
                      Text('Tipo de restaurante'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _createList(items) {
    List<Widget> lists = <Widget>[];
    if (items.isEmpty) {
      lists.add(const Center(child: Text('Ingresa otros datos')));
      return lists;
    }
    items.forEach((element) => {lists.add(_buildCard(element))});
    return lists;
  }

  Widget _buildCard(data) {
    data['media_gallery_entries'] = [];
    data['media_gallery_entries'].add({
      "media_type": "image",
      'file': getCustomAttribute(data['custom_attributes'], 'image')
    });
    data['media_gallery_entries'].add({
      "media_type": "image",
      'file': getCustomAttribute(data['custom_attributes'], 'small_image')
    });
    data['media_gallery_entries'].add({
      "media_type": "image",
      'file': getCustomAttribute(data['custom_attributes'], 'small_image')
    });

    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'detail', arguments: data),
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 10,
        child: SizedBox(
          height: 200,
          child: Stack(children: <Widget>[
            Positioned(
              left: 10,
              top: 15,
              bottom: 15,
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, 'detail', arguments: data),
                child: Container(
                  width: 120,
                  height: 90,
                  decoration: getImg(
                      getCustomAttribute(data['custom_attributes'], 'image')),
                ),
              ),
            ),
            Positioned(
              left: 140,
              top: 10,
              right: 65,
              bottom: 5,
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, 'detail', arguments: data),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            transformPrice(data['price'].toString()),
                            style: const TextStyle(fontSize: 14),
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
            Positioned(left: 133, bottom: 33, child: crearSlot(data))

            //TimeSlotButton(
            //anchoButton: 10, altoButton: 35, sizeText: 13)),
          ]),
        ),
      ),
    );
  }

  BoxDecoration getImg(String? img) {
    if (img != null) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: NetworkImage(
            pathMedia(img),
          ),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: const DecorationImage(
          image: AssetImage('assets/notFoundImg.png'),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget crearSlider(Respuesta model) {
    if (model.result == 'fail') {
      return const Center(
        child: Text('Ocurrio un error al obtener los datos'),
      );
    }

    if (model.data == null) {
      return const Center(
        child: Text('No Cuentas con una sesion'),
      );
    }

    List<Widget> list = [];
    for (dynamic item in model.data!['data']['items']) {
      item['media_gallery_entries'] = [];
      if (item['images'] != null) {
        item['media_gallery_entries'] = item['images'];
      }
      list.add(cardRestaurant(item));
    }

    return CarouselSlider(
        options: CarouselOptions(
          height: 450.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          enableInfiniteScroll: true,
          viewportFraction: 0.8,
        ),
        items: list);
  }

  cardRestaurant(data) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'detail', arguments: data),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          FadeInImage(
            image: data['media_gallery_entries'] != null &&
                    data['media_gallery_entries'].length > 0
                ? NetworkImage(
                    pathMedia(data['media_gallery_entries'][0]['file']))
                : const AssetImage('assets/notFoundImg.png'),
            placeholder: const AssetImage('assets/notFoundImg.png'),
            fit: BoxFit.cover,
            height: 125,
            width: 300,
          ),
          Row(
            children: [
              Text(
                data['name'],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Exo Bold',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RatingBarIndicator(
                rating: double.parse(getCustomAttribute(
                        data['custom_attributes'], 'product_score')
                    .toString()),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                itemCount: 5,
                itemSize: 22.0,
                direction: Axis.horizontal,
              ),
              Text(
                "${getCustomAttribute(data['custom_attributes'], 'product_score')} reseñas",
                style: const TextStyle(
                    color: Colors.black, fontSize: 12, fontFamily: 'Exo Bold'),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Comida',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Exo Regular'),
              ),
              const Text(
                ' * ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Exo Regular'),
              ),
              Text(
                transformPrice(data['price'].toString()),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Exo Regular'),
              ),
              const Text(
                ' * ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Exo Regular'),
              ),
              Text(
                "${getCustomAttribute(data['custom_attributes'], 'product_city').replaceAll(' - ', '/')}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Exo Regular'),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          crearSlotSlider(data)
        ]),
      ),
    );
  }

  Padding preSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .3,
        child: BlocProvider(
          create: (_) => _firstBloc,
          child: BlocListener<OneBloc, OneState>(
            listener: (context, state) {
              if (state is OneError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                  ),
                );
              }
            },
            child: BlocBuilder<OneBloc, OneState>(
              builder: (context, state) {
                if (state is OneInitial) {
                  return _buildLoading();
                } else if (state is OneLoading) {
                  return _buildLoading();
                } else if (state is OneLoaded) {
                  return crearSlider(state.data);
                  //return Text('En mantenimiento');
                } else if (state is OneError) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget crearSlotSlider(data) {
    List<String> horas = [];
    if (data['extension_attributes'] != null) {
      if (data['extension_attributes']['slot_schedules'] != null) {
        for (dynamic attr in data['extension_attributes']['slot_schedules']) {
          if (attr['attribute_code'] == _now.weekday) {
            if (!attr['value'].isEmpty) {
              if (attr['value'][0]['slots_info'] == null) {
                horas.add(attr['value'][0]['from']);
              } else {
                if (!attr['value'][0]['slots_info'].isEmpty) {
                  for (dynamic item in attr['value'][0]['slots_info']) {
                    final HoraAcutal = item['time']
                        .replaceAll(" am", "")
                        .replaceAll(" pm", "")
                        .split(':');
                    int hour = int.parse(HoraAcutal[0]);
                    int minute = int.parse(HoraAcutal[1]);
                    if (_now.hour == hour && _now.minute <= minute) {
                      horas.add(item['time']);
                    }
                    horas.add(item['time']);
                  }
                } /*else {
                  print('data is empty 2' + data['name']);
                }*/
              }
            } /*else {
              //print('data is empty ' + data['name']);
            }*/
          }
        }
      }
    }

    return TimeSlotButton(
        anchoButton: 20,
        altoButton: 40,
        sizeText: 12,
        horas: horas,
        data: data);
  }

  Widget crearSlot(data) {
    List<String> horas = [];
    if (data['extension_attributes'] != null) {
      if (data['extension_attributes']['slot_schedules'] != null) {
        for (dynamic attr in data['extension_attributes']['slot_schedules']) {
          if (attr['attribute_code'] == _now.weekday) {
            if (!attr['value'].isEmpty) {
              if (attr['value'][0]['slots_info'] == null) {
                horas.add(attr['value'][0]['from']);
              } else {
                if (!attr['value'][0]['slots_info'].isEmpty) {
                  for (dynamic item in attr['value'][0]['slots_info']) {
                    final HoraAcutal = item['time']
                        .replaceAll(" am", "")
                        .replaceAll(" pm", "")
                        .split(':');
                    int hour = int.parse(HoraAcutal[0]);
                    int minute = int.parse(HoraAcutal[1]);
                    if (_now.hour == hour && _now.minute <= minute) {
                      horas.add(item['time']);
                    }
                    horas.add(item['time']);
                  }
                } /*else {
                  print('data is empty 2' + data['name']);
                }*/
              }
            } /*else {
              print('data is empty ' + data['name']);
            }*/
          }
        }
      }
    }

    return TimeSlotButton(
        anchoButton: 15,
        altoButton: 40,
        sizeText: 11,
        horas: horas,
        data: data);
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
