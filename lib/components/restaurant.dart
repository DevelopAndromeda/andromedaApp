import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/utilities/constanst.dart';

class RestuarentScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  const RestuarentScreen({Key? key, required this.data}) : super(key: key);

  @override
  _RestuarentScreenState createState() => _RestuarentScreenState();
}

class _RestuarentScreenState extends State<RestuarentScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.data['sku']);
    print(widget.data['media_gallery_entries']);
    print(widget.data['images']);
    //print(widget.data['media_gallery_entries']);
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            'detail', arguments: widget.data, (Route<dynamic> route) => false);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
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
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
                        fontSize: 14,
                        fontFamily: 'Exo Bold'),
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
                      if (favorite['success']) {
                        responseSuccessWarning(
                            context, "Se agrego a favoritos");
                      }

                      //print(favorite);
                    },
                    iconSize: 20,
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text(
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
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 20, 20, 20),
                        ),
                        itemCount: 5,
                        itemSize: 12.0,
                        direction: Axis.horizontal,
                      ),
                      Text(
                        "${getCustomAttribute(widget.data['custom_attributes'], 'product_score')}",
                        style: const TextStyle(
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
}
