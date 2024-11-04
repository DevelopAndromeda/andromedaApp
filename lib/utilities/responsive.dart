import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  //final Widget web;

  const Responsive({super.key, required this.tablet, required this.mobile});

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800 &&
        MediaQuery.of(context).size.width < 1200;
  }

  /*static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800;
  }

  static bool isLessThan1250(BuildContext context) {
    return MediaQuery.of(context).size.width < 1250;
  }

  static bool isLessThan900(BuildContext context) {
    return MediaQuery.of(context).size.width < 900;
  }

  static bool isLessThan480(BuildContext context) {
    return MediaQuery.of(context).size.width < 480;
  }*/

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      if (cons.maxWidth < 1200 && cons.maxWidth > 800) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
