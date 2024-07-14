import 'package:andromeda/utilities/strings.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/utilities/text_style.dart';

class NoSearchResultFound extends StatelessWidget {
  const NoSearchResultFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/no_search_result.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 260,
            left: 30,
            child: Text(
              MyString.oopsMsg,
              style: kTitleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 35,
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 30,
            child: Text(
              MyString.notResult,
              style: kSubtitleTextStyle.copyWith(
                color: Colors.white54,
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
