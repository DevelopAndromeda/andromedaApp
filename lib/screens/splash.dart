import 'package:flutter/material.dart';

import 'package:andromeda/services/customer.dart';

class MySplashPage extends StatefulWidget {
  const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _MySplashState();
}

class _MySplashState extends State<MySplashPage> {
  void init() async {
    await CustomerService().getUserSession().then((value) {
      String pantalla = 'login';
      if (value.result == 'ok') {
        if (value.data!.isNotEmpty) {
          pantalla = 'home';
        }
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(pantalla, (Route<dynamic> route) => false);
      });
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
