import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/reviews/reviews_bloc.dart';
import '../../../utilities/constanst.dart';

import './rating_rogress_indicador.dart';
import './users_review_card.dart';

class ReviewsInfo extends StatefulWidget {
  const ReviewsInfo(
      {super.key,
      /*required this.categorie,
    required this.name,
    required this.description,*/
      required this.rating,
      required this.sku
      /*required this.numOfReviews,*/
      });

  /*final String categorie, name, description;*/
  final double rating;
  final String sku;

  @override
  State<ReviewsInfo> createState() => _ReviewsInfoState();
}

class _ReviewsInfoState extends State<ReviewsInfo> {
  final ReviewsBloc _reviewBloc = ReviewsBloc();

  @override
  void initState() {
    _reviewBloc.add(GetReviewsList(widget.sku));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Las evaluaciones y reseñas están verificadas y provienen de personas que usan el mismo tipo de dispositivo que usted.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          /*Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  widget.rating.toString(),
                  style: const TextStyle(fontSize: 50),
                ),
              ),
              const Expanded(
                flex: 7,
                child: Column(
                  children: [
                    RatingProgressIndicador(
                      text: '5',
                      value: 1.0,
                    ),
                    RatingProgressIndicador(
                      text: '4',
                      value: 0.8,
                    ),
                    RatingProgressIndicador(
                      text: '3',
                      value: 0.6,
                    ),
                    RatingProgressIndicador(
                      text: '2',
                      value: 0.4,
                    ),
                    RatingProgressIndicador(
                      text: '1',
                      value: 0.2,
                    )
                  ],
                ),
              )
            ],
          ),*/
          Text(
            widget.rating.toString(),
            style: const TextStyle(fontSize: 50),
          ),
          RatingBarIndicator(
            rating: widget.rating,
            itemSize: 20,
            unratedColor: Colors.grey,
            itemBuilder: (_, __) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocProvider(
            create: (_) => _reviewBloc,
            child: BlocListener<ReviewsBloc, ReviewsState>(
              listener: (context, state) {
                /*if (state is UserError) {
                          responseErrorWarning(context, state.message!);
                        }*/
              },
              child: BlocBuilder<ReviewsBloc, ReviewsState>(
                builder: (context, state) {
                  if (state is ReviewsLoaded) {
                    if (state.data.result == 'fail') {
                      return const Center(
                          child: Text('No existen comentarios'));
                    }

                    return Column(
                      children: _createList(state.data.data!['data']),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> _createList(datas) {
    List<Widget> lists = <Widget>[];
    for (dynamic data in datas) {
      lists.add(UsersReviewCard(data: data));
    }
    return lists;
  }
}
