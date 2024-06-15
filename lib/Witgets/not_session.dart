import 'package:flutter/material.dart';

import 'package:andromeda/utilities/strings.dart';
import 'package:andromeda/utilities/text_style.dart';

class WrongConnection extends StatelessWidget {
  const WrongConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/Connection_Lost.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              MyString.oopsMsg,
              style: kTitleTextStyle.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              MyString.notSession,
              style: kSubtitleTextStyle.copyWith(
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
