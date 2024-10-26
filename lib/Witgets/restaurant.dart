import 'package:appandromeda/witgets/time_slot_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:appandromeda/services/api.dart';
import 'package:appandromeda/services/db.dart';

import 'package:appandromeda/utilities/constanst.dart';

class RestuarentScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  const RestuarentScreen({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _RestuarentScreenState createState() => _RestuarentScreenState();
}

class _RestuarentScreenState extends State<RestuarentScreen> {
  final DateTime _now = DateTime.now();
  bool isFavorite = false;
  Future getDataLocalBd(int id) async {
    var favorite = await serviceDB.instance.getById('favorites', 'id', id);
    if (favorite.isNotEmpty) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.data['isFavorite']);
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, 'detail', arguments: widget.data),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FadeInImage(
                  image: widget.data['media_gallery_entries'] != null &&
                          widget.data['media_gallery_entries'].length > 0
                      ? NetworkImage(pathMedia(
                          widget.data['media_gallery_entries'][0]['file']))
                      : const AssetImage('assets/notFoundImg.png'),
                  placeholder: const AssetImage('assets/notFoundImg.png'),
                  fit: BoxFit.cover,
                  height: 125,
                  width: 250,
                ),
                //fadeOutCurve: Curves.bounceIn
              ),
              Row(
                children: [
                  Text(
                    widget.data['name'],
                    style: const TextStyle(
                        color: Color(0xff323232),
                        fontSize: 18,
                        fontFamily: 'Exo Bold',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      final user = await serviceDB.instance
                          .getById('users', 'id_user', 1);
                      if (user.isEmpty) {
                        return;
                      }
                      String token = user[0]['token'];
                      var favorite = await post(
                          token,
                          'custom',
                          'wishlist/customer/product/${widget.data["id"]}',
                          {},
                          '');
                      print('favorite');
                      print(favorite);
                      //if (favorite['success']) {*/
                      final favoriteExist = await serviceDB.instance.getById(
                          'favorites',
                          'id',
                          int.parse(widget.data["id"].toString()));
                      print(favoriteExist);
                      if (favoriteExist != null ||
                          favoriteExist[0].isNotEmpty) {
                        await serviceDB.instance.insertRecord('favorites',
                            {'id': int.parse(widget.data["id"].toString())});
                        responseSuccessWarning(
                            context, "Se agrego a favoritos");
                      }
                      setState(() {
                        widget.data['isFavorite'] = true;
                      });
                    },
                    iconSize: 22,
                    icon: Icon(
                      widget.data['isFavorite']
                          ? Icons.bookmark
                          : Icons.bookmark_outline_rounded,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: double.parse(getCustomAttribute(
                            widget.data['custom_attributes'], 'product_score')
                        .toString()),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color.fromARGB(200, 149, 4, 4),
                    ),
                    itemCount: 5,
                    itemSize: 22.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${getCustomAttribute(widget.data['custom_attributes'], 'product_score')} reseñas",
                    style: const TextStyle(
                        color: Color(0xff323232),
                        fontSize: 12,
                        fontFamily: 'Exo Bold'),
                  ),
                ],
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*const Text(
                    'Comida',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),*/
                  Text(
                    ' *' +
                        transformPrice(widget.data['price'].toString()) +
                        '* ',
                    style: const TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),
                  Text(
                    "${getCustomAttribute(widget.data['custom_attributes'], 'product_city').replaceAll(' - ', '/')}",
                    style: const TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),
                ],
              )),
              crearSlot()
            ],
          ),
        ),
      ),
    );
  }

  Widget crearSlot() {
    List<String> horas = [];
    if (widget.data['extension_attributes'] == null) {
      for (dynamic attr in widget.data['custom_attributes']) {
        if (attr['attribute_code'].runtimeType == int &&
            attr['attribute_code'] == _now.weekday) {
          if (!attr['value'].isEmpty) {
            if (attr['value'][0]['slots_info'] == null) {
              horas.add(attr['value'][0]['from']);
            } else {
              if (!attr['value'][0]['slots_info'].isEmpty) {
                //print(attr['value'][0]['slots_info']);
                for (dynamic item in attr['value'][0]['slots_info']) {
                  /*final HoraAcutal = item['time']
                      .replaceAll(" am", "")
                      .replaceAll(" pm", "")
                      .split(':');*/
                  //int hour = int.parse(HoraAcutal[0]);
                  //if (_now.hour <= hour /*&& _now.minute <= minute*/) {
                  horas.add(item['time']);
                  //}
                }
              } /*else {
                print('data is empty 2' + widget.data['name']);
              }*/
            }
          } /*else {
            print('data is empty ' + widget.data['name']);
          }*/
        }
      }
    } else {
      if (widget.data['extension_attributes']['slot_schedules'] != null) {
        for (dynamic attr in widget.data['extension_attributes']
            ['slot_schedules']) {
          if (attr['attribute_code'] == _now.weekday) {
            if (!attr['value'].isEmpty) {
              if (attr['value'][0]['slots_info'] == null) {
                horas.add(attr['value'][0]['from']);
              } else {
                if (!attr['value'][0]['slots_info'].isEmpty) {
                  for (dynamic item in attr['value'][0]['slots_info']) {
                    /*final HoraAcutal = item['time']
                        .replaceAll(" am", "")
                        .replaceAll(" pm", "")
                        .split(':');*/
                    //int hour = int.parse(HoraAcutal[0]);
                    //if (_now.hour <= hour && _now.minute <= minute) {
                    horas.add(item['time']);
                    //}
                    //horas.add(item['time']);
                  }
                } /*else {
                  print('data is empty 2' + widget.data['name']);
                }*/
              }
            } /*else {
              print('data is empty ' + widget.data['name']);
            }*/
          }
        }
      }
    }

    return TimeSlotButton(
        anchoButton: 20,
        altoButton: 40,
        sizeText: 10,
        horas: horas,
        data: widget.data);
  }
}
