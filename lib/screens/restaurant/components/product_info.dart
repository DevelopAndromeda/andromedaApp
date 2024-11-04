import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html_parsed_read_more/html_parsed_read_more.dart';

import '../../../utilities/constanst.dart';
//import 'product_availability_tag.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo(
      {super.key,
      required this.categorie,
      required this.name,
      required this.description,
      required this.rating,
      required this.numOfReviews,
      required this.price});

  final String categorie, name, description;
  final double rating, price;
  final int numOfReviews;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: defaultPadding),
          dividerLine,
          const SizedBox(height: defaultPadding),
          Center(
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
            ),
          ),
          Center(
            child: /*ListTile(
              leading: */
                RatingBarIndicator(
              rating: rating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Color.fromARGB(200, 149, 4, 4),
              ),
              itemCount: 5,
              itemSize: 25.0,
              direction: Axis.horizontal,
            ),
            //title: Text("($rating)"),
            //),
          ),
          const SizedBox(height: defaultPadding),
          dividerLine,
          /*Container(
            height: 35.0,
            child: ListTile(
              leading: Icon(Icons.comment_bank_outlined),
              title: Text("$numOfReviews Reseñas"),
              //subtitle: Text('Supporting text'),
            ),
          ),*/
          Container(
            height: 35.0,
            child: ListTile(
              leading: Icon(Icons.money_outlined),
              title: Text("Desde: MXN$price"),
              //subtitle: Text('Supporting text'),
            ),
          ),
          Container(
            height: 35.0,
            child: ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(categorie),
              //subtitle: Text('Supporting text'),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: HtmlParsedReadMore(
              readLessText: 'Ver menos',
              readMoreText: 'Más información',
              maxLinesReadLess: 3,
              maxLinesReadMore: 1000,
              textOverflow: TextOverflow.ellipsis,
              fontFamily: 'poppins',
              textButtonFontSize: 14.0,
              buttonAlignment: Alignment.bottomLeft,
              buttonPadding: const EdgeInsets.only(top: 0),
              text: description,
            ),
          ),
        ]),
      ),
    );
  }
}
