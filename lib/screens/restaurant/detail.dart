import 'package:flutter/material.dart';

import '../../utilities/strings.dart';
import '../../utilities/constanst.dart';

import 'components/detail_img.dart';
import 'components/product_info.dart';
import 'components/map_info.dart';
import 'components/formulario.dart';
import 'components/reviews_info.dart';

class MyDetailPage extends StatelessWidget {
  const MyDetailPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(slivers: [
        SliverAppBar(
          title: Text(MyString.restaurantDetail),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          floating: true,
        ),
        DetailImages(
          data: data['media_gallery_entries'],
        ),
        ProductInfo(
            name: data['name'],
            categorie: getCustomAttribute(
                data['custom_attributes'], 'category_string'),
            description: getCustomAttribute(
                data['custom_attributes'], 'short_description'),
            rating: double.parse(
                getCustomAttribute(data['custom_attributes'], 'product_score')
                    .toString()),
            numOfReviews: 126,
            price: double.parse(data['price'].toString())),
        FormularioOrden(
          sku: data['sku'],
          id: data['id'].toString(),
          custom_attributes: data['custom_attributes'],
        ),
        MapInfo(
            hotelAddress:
                getCustomAttribute(data['custom_attributes'], 'hotel_address'),
            location:
                getCustomAttribute(data['custom_attributes'], 'location')),
        ReviewsInfo(
          rating: double.parse(
              getCustomAttribute(data['custom_attributes'], 'product_score')
                  .toString()),
          sku: data['sku'],
        )
      ]),
    ));
  }
}
