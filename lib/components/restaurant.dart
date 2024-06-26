import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/utilities/constanst.dart';

class RestuarentScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  const RestuarentScreen({Key? key, required this.data}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RestuarentScreenState createState() => _RestuarentScreenState();
}

class _RestuarentScreenState extends State<RestuarentScreen> {
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
    final height = MediaQuery.of(context).size.height * 2;
    final width = MediaQuery.of(context).size.width * 1;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: widget.data);
        /*Navigator.of(context).pushNamedAndRemoveUntil(
            'detail', arguments: widget.data, (Route<dynamic> route) => false);*/
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
          margin: const EdgeInsets.all(1.0),
          height: height * .6,
          width: width * .6,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  child: widget.data['media_gallery_entries'] != null &&
                          widget.data['media_gallery_entries'].length > 0
                      ? Image.network(pathMedia(
                          widget.data['media_gallery_entries'][0]['file']))
                      : Image.asset('assets/notFoundImg.png'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data['name'],
                    style: const TextStyle(
                        color: Color(0xff323232),
                        fontSize: 18,
                        fontFamily: 'Exo Bold',
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      final user = await serviceDB.instance
                          .getById('users', 'id_user', 1);
                      if (user.isEmpty) {
                        return;
                      }
                      String token = user[0]['token'];
                      final favorite = await post(
                          token,
                          'custom',
                          'wishlist/customer/product/${widget.data["id"]}',
                          {},
                          '');
                      print(favorite);
                      if (favorite['success']) {
                        await serviceDB.instance.insertRecord(
                            'favorites', {'id': widget.data["id"]});
                        responseSuccessWarning(
                            context, "Se agrego a favoritos");
                      }

                      //print(favorite);
                    },
                    iconSize: 22,
                    icon: Icon(
                      isFavorite
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
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${getCustomAttribute(widget.data['custom_attributes'], 'product_score')} reseñas",
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 12,
                        fontFamily: 'Exo Bold'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comida',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),
                  const Text(
                    r'$$$$',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),
                  Text(
                    "${getCustomAttribute(widget.data['custom_attributes'], 'product_city')}",
                    style: const TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  Icon(Icons.auto_graph_sharp),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Reservado 20 veces hoy',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Exo Regular'),
                  ),
                ],
              )
              /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.directions_bike,
                    size: 14,
                    color: Color(0xffd60265),
                  ),
                  Text(
                    r"  Rs  9000",
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),
                ],
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
