import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/utilities/constanst.dart';

class MyReviewPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const MyReviewPage({super.key, required this.data});

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  Future getReviwes() async {
    return await get(
        '', 'integration', 'products/${widget.data["sku"]}/reviews');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.data['name']),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 60),
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
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                        getCustomAttribute(widget.data['custom_attributes'],
                                'product_score')
                            .toString(),
                        style: const TextStyle(fontSize: 50))),
                Expanded(
                  flex: 7,
                  child: Column(
                    children: const [
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
            ),
            RatingBarIndicator(
              rating: double.parse(getCustomAttribute(
                      widget.data['custom_attributes'], 'product_score')
                  .toString()),
              itemSize: 20,
              unratedColor: Colors.grey,
              itemBuilder: (_, __) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
            const Text('12,600'),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: getReviwes(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //return Text('data');

                  return Column(
                    children: _createList(snapshot.data),
                  );
                  //return _createList(snapshot.data);
                })
            //UsersReviewCard(),
            //UsersReviewCard()
          ]),
        ),
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

class RatingProgressIndicador extends StatelessWidget {
  const RatingProgressIndicador(
      {super.key, required this.text, required this.value});

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(text)),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: 20,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 15,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}

class UsersReviewCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const UsersReviewCard({super.key, required this.data});
  //const UsersReviewCard({Key? key}) : super(key: key, required this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/Profile.png'),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(data['nickname'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(
          width: 30,
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: 3,
              itemSize: 15,
              unratedColor: Colors.grey,
              itemBuilder: (_, __) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(data['created_at']),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(data['title'],
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ReadMoreText(
          data['detail'],
          trimLines: 1,
          trimMode: TrimMode.Line,
          trimExpandedText: ' Ver menos',
          trimCollapsedText: ' Ver mas',
          moreStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
          lessStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
