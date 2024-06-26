import 'package:flutter/material.dart';

class MySplashPage extends StatefulWidget {
  const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _MySplashState();
}

class _MySplashState extends State<MySplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushNamed(context, 'home');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
