import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final int cantData;
  const Skeleton({super.key, required this.cantData});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: cantData, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return const ListTile(
              title: Card(
            margin: EdgeInsets.all(5),
            elevation: 10,
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: SizedBox(width: 100, height: 90),
            ),
          ));
        },
      ),
    );
  }
}
