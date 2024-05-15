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
    //return await get('', 'integration',
    //    'products/?searchCriteria[sortOrders][0][direction]=ASC&searchCriteria[currentPage]=1&searchCriteria[pageSize]=3&searchCriteria[filterGroups][0][filters][1][field]=category_id&searchCriteria[filterGroups][0][filters][1][value]=3&searchCriteria[filterGroups][0][filters][1][conditionType]=eq');
    return await get('', 'integration',
        'products/?searchCriteria[filterGroups][0][filters][0][field]=category_string&searchCriteria[filterGroups][0][filters][0][value]=%25destacados%25&searchCriteria[filterGroups][0][filters][0][conditionType]=like');
  }

  Future getSecondSection() async {
    //return await get('', 'integration',
    //    'products/?searchCriteria[sortOrders][0][direction]=ASC&searchCriteria[currentPage]=2&searchCriteria[pageSize]=3&searchCriteria[filterGroups][0][filters][1][field]=category_id&searchCriteria[filterGroups][0][filters][1][value]=3&searchCriteria[filterGroups][0][filters][1][conditionType]=eq');
    return await get(
        '', 'integration', 'threedadv-catalog/most-viewed?pageSize=10&city=2');
  }

  Future getAllRestaurants() async {
    return await get('', 'integration',
        'products/?searchCriteria[sortOrders][0][direction]=ASC&searchCriteria[currentPage]=1&searchCriteria[pageSize]=10&searchCriteria[filterGroups][0][filters][1][field]=category_id&searchCriteria[filterGroups][0][filters][1][value]=3&searchCriteria[filterGroups][0][filters][1][conditionType]=eq');
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
                        backgroundColor: Color.fromARGB(255, 8, 8, 8),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            'profile', (Route<dynamic> route) => false);
                      },
                    ),
                    const SizedBox(height: 20)
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
                'Mas Vistos',
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
                'Todos los Restaurantes',
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
                height: 30,
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
      //final score = getScore(data['custom_attributes']);
      /*lists.add(RestuarentScreen(
        id: data['id'],
        name: data['name'],
        image: "http://82.165.212.67/media/catalog/product" +
            data['media_gallery_entries'][0]['file'],
        remainingTime: '',
        subTitle: 'Tipo de Comida',
        rating: getCustomAttribute(data['custom_attributes'], 'product_score'),
        deliveryTime: '',
        totalRating: '560',
        deliveryPrice: '',
      ));*/
      lists.add(RestuarentScreen(data: data));
    }
    return lists;
  }
}
