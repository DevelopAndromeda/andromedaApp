import 'package:andromeda/screens/andromeda/history.dart';
import 'package:andromeda/screens/andromeda/notifications.dart';
import 'package:andromeda/screens/andromeda/saved.dart';
import 'package:andromeda/screens/andromeda/search.dart';
import 'package:andromeda/screens/andromeda/stores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:andromeda/witgets/bottom_bar.dart';
import 'package:andromeda/blocs/bottom/bottom_navigation_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = '';

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
    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, int>(
        builder: (context, currentTab) {
          if (currentTab == 0) {
            return const MySearchPage();
          }
          if (currentTab == 1) {
            return const MyHistoryPage();
          }
          if (currentTab == 2) {
            return const MyStorePage();
          }
          if (currentTab == 3) {
            return const MySavedPage();
          }
          if (currentTab == 4) {
            return const MyNotificationsPage();
          }
          return Text('Default: $currentTab ');
        },
      ),
      bottomNavigationBar: const MyBottomBar(),
    );
  }
}
