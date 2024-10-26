import 'package:appandromeda/screens/andromeda/history.dart';
import 'package:appandromeda/screens/andromeda/notifications.dart';
import 'package:appandromeda/screens/andromeda/saved.dart';
import 'package:appandromeda/screens/andromeda/search.dart';
import 'package:appandromeda/screens/andromeda/stores.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appandromeda/witgets/bottom_bar.dart';
import 'package:appandromeda/blocs/bottom/bottom_navigation_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget paginaActual(int status) {
    Map<int, Widget> map = {
      0: const MySearchPage(),
      1: const MyHistoryPage(),
      2: const MyStorePage(),
      3: const MySavedPage(),
      4: const MyNotificationsPage()
    };

    return map[status] ?? const MyStorePage();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //FlutterBackgroundService().invoke("setAsBackground");
    //FlutterBackgroundService().invoke("setAsBackground");
    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, int>(
        builder: (context, currentTab) {
          return paginaActual(currentTab);
        },
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}
