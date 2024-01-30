import 'package:flutter/material.dart';
import 'package:andromeda/components/restaurant.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/Witgets/bottomBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = '';

  /*Map<int, StatefulWidget> rutas = {
    0: const MySearchPage(),
    1: const MyHistoryPage(),
    3: const MySavedPage(),
    4: const MyNotificationsPage(),
  };*/

  Future getFirstSection() async {
    return await get('', 'integration',
        'products/?searchCriteria%5BsortOrders%5D%5B0%5D%5Bdirection%5D=ASC&searchCriteria%5BcurrentPage%5D=1&searchCriteria%5BpageSize%5D=3&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5Bfield%5D=category_id&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5Bvalue%5D=3&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5BconditionType%5D=eq');
  }

  Future getSecondSection() async {
    return await get('', 'integration',
        'products/?searchCriteria%5BsortOrders%5D%5B0%5D%5Bdirection%5D=ASC&searchCriteria%5BcurrentPage%5D=2&searchCriteria%5BpageSize%5D=3&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5Bfield%5D=category_id&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5Bvalue%5D=3&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5BconditionType%5D=eq');
  }

  Future getAllRestaurants() async {
    return await get('', 'integration',
        'products/?searchCriteria%5BsortOrders%5D%5B0%5D%5Bdirection%5D=ASC&searchCriteria%5BcurrentPage%5D=1&searchCriteria%5BpageSize%5D=10&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5Bfield%5D=category_id&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5Bvalue%5D=3&searchCriteria%5BfilterGroups%5D%5B0%5D%5Bfilters%5D%5B1%5D%5BconditionType%5D=eq');
  }

  Future<void> getUserData() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isNotEmpty) {
      print(sesion[0]);
      username = sesion[0]['nombre'];
    }
    setState(() {});
  }

  Future<void> _setCoords() async {
    dynamic geo = await determinePosition();
    print(geo);
    Map<String, dynamic> _update = {'lat': geo.longitude, 'long': geo.latitude};
    await serviceDB.instance.updateRecord('users', _update, 'id_user', 1);
  }

  @override
  void initState() {
    super.initState();

    _setCoords();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      //body: rutas[_currentIndex],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                      title: Text(
                        "Buenas Tardes, ${username}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      trailing: const CircleAvatar(
                        radius: 30,
                        /*minRadius: 20,
                        maxRadius: 50,*/
                        //backgroundImage: AssetImage('assets/burger.jpg'),
                        backgroundColor: Color.fromARGB(255, 154, 126, 43),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('profile');
                      },
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
              const Text(
                'Destacados',
                style: TextStyle(
                    color: Color(0xff323232),
                    fontSize: 15,
                    fontFamily: 'Exo Bold'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  child: FutureBuilder(
                      future: getFirstSection(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //print(snapshot.data['items']);
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData) {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: _createList(snapshot.data['items']),
                          );
                        } else {
                          return const Text('Error en api');
                        }
                      }),
                ),
              ),
              const Text(
                'Destacados',
                style: TextStyle(
                    color: Color(0xff323232),
                    fontSize: 15,
                    fontFamily: 'Exo Bold'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  child: FutureBuilder(
                      future: getSecondSection(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //print(snapshot.data['items']);
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData) {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: _createList(snapshot.data['items']),
                          );
                        } else {
                          return const Text('Error en api');
                        }
                      }),
                ),
              ),
              const Text(
                'Todos los Restuarentes',
                style: TextStyle(
                    color: Color(0xff323232),
                    fontSize: 15,
                    fontFamily: 'Exo Bold'),
              ),
              Container(
                height: height * .35,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder(
                    future: getAllRestaurants(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //print(snapshot.data['items']);
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasData) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: _createList(snapshot.data['items']),
                        );
                      } else {
                        return const Text('Error en api');
                      }
                    }),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomBar(
        index: 2,
      ),
    );
  }

  List<Widget> _createList(datas) {
    List<Widget> lists = <Widget>[];
    for (dynamic data in datas) {
      lists.add(RestuarentScreen(
        name: data['name'],
        image: "http://82.165.212.67/media/catalog/product" +
            data['media_gallery_entries'][0]['file'],
        remainingTime: '',
        subTitle: 'Tipo de Comida',
        rating: '4.5',
        deliveryTime: '',
        totalRating: '560',
        deliveryPrice: '',
      ));
    }
    return lists;
  }
}
