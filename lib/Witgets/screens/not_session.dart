import 'package:flutter/material.dart';

import '../../witgets/boton_base.dart';

//import 'package:appandromeda/utilities/strings.dart';
//import 'package:appandromeda/utilities/text_style.dart';

class WrongConnection extends StatelessWidget {
  const WrongConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/screens/Connection_Lost.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          /*Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              MyString.oopsMsg,
              style: kTitleTextStyle.copyWith(
                color: Colors.black,
              ),
            ),
          ),*/
          /*Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              MyString.notSession,
              style: kSubtitleTextStyle.copyWith(
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),*/
          Positioned(
            bottom: 80,
            left: 50,
            right: 50,
            child: MyBaseButtom(
              onPressed: () => Navigator.pushNamed(context, 'login'),
              text: const Text(
                "Iniciar Sesion",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
