import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

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
            Expanded(
              child: Text(
                data['title'],
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: ReadMoreText(
              data['detail'],
              trimLines: 1,
              trimMode: TrimMode.Line,
              textAlign: TextAlign.left,
              trimExpandedText: ' Ver menos',
              trimCollapsedText: ' Ver mas',
              moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              lessStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            )),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
