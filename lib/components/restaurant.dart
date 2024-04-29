import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

class RestuarentScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  const RestuarentScreen({Key? key, required this.data}) : super(key: key);

  @override
  _RestuarentScreenState createState() => _RestuarentScreenState();
}

class _RestuarentScreenState extends State<RestuarentScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.data['image']);
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            'detail', arguments: widget.data, (Route<dynamic> route) => false);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          /*decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
          margin: const EdgeInsets.all(1.0),*/
          height: height * .5,
          width: width * .5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          "http://82.165.212.67/media/catalog/product" +
                              widget.data['media_gallery_entries'][0]['file'],
                          width: 300,
                          height: 180)),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 154, 126, 43),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 7, left: 5, right: 10, bottom: 7),
                        child: Text(
                          "Flash 20% OFF",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Exo Bold'),
                        ),
                      ),
                    ),
                  ),*/
                  /*Positioned(
                    bottom: 0,
                    left: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xfffffcff),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                            widget.remainingTime,
                            style: TextStyle(
                                color: Color(0xff323232),
                                fontSize: 12,
                                fontFamily: 'Exo Bold'),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data['name'],
                    style: TextStyle(
                        color: Color(0xff323232),
                        fontSize: 14,
                        fontFamily: 'Exo Bold'),
                  ),
                  IconButton(
                    onPressed: () async {
                      print('click');
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
                    },
                    iconSize: 20,
                    icon: Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Tipo de Comida',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                        fontFamily: 'Exo Regular'),
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: double.parse(getCustomAttribute(
                                widget.data['custom_attributes'],
                                'product_score')
                            .toString()),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 12.0,
                        direction: Axis.horizontal,
                      ),
                      Text(
                        " " +
                            getCustomAttribute(widget.data['custom_attributes'],
                                    'product_score')
                                .toString(),
                        style: TextStyle(
                            color: Color(0xff323232),
                            fontSize: 12,
                            fontFamily: 'Exo Light'),
                      ),
                      /*Text(
                        "  (" + widget.totalRating + ")",
                        style: TextStyle(
                            color: Color(0xffa9a9a9),
                            fontSize: 12,
                            fontFamily: 'Exo Bold'),
                      ),*/
                    ],
                  )
                ],
              ),
              /*SizedBox(
                height: 3,
              ),*/
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
                    r"  Rs  " + widget.deliveryPrice,
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

  getCustomAttribute(data, type) {
    if (data.length == 0) {
      return '';
    }

    Map<String, String> typeValue = {'product_score': '0'};
    String? value = typeValue[type] ?? '';
    for (dynamic attr in data) {
      if (attr['attribute_code'] == type) {
        value = attr['value'];
      }
    }
    return value;
  }
}
