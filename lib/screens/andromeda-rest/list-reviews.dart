import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';
import 'package:andromeda/screens/andromeda-rest/menu.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListReview extends StatefulWidget {
  const ListReview({super.key});

  @override
  State<ListReview> createState() => _ListReviewState();
}

class _ListReviewState extends State<ListReview> {
  final String _url =
      "${dotenv.env['PROTOCOL']}://${dotenv.env['URL']}/media/catalog/product";
  Future getRestaurant() async {
    final user = await serviceDB.instance.getById('users', 'id_user', 1);

    if (user.isEmpty) {
      return;
    }

    return await get('', 'integration',
        'products/?searchCriteria[filterGroups][0][filters][0][field]=created_by&searchCriteria[filterGroups][0][filters][0][value]=${user[0]['id']}&searchCriteria[filterGroups][0][filters][0][conditionType]=eq');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(changeSalida: () {}),
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: const Text('Comentarios'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getRestaurant(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  /*return const Center(
                    child: CircularProgressIndicator(),
                  );*/
                  return Column(children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Card(
                                margin: const EdgeInsets.all(20),
                                elevation: 10,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Container(
                                    width: 100,
                                    height: 90,
                                  ),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.all(20),
                                elevation: 10,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Container(
                                    width: 100,
                                    height: 90,
                                  ),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.all(20),
                                elevation: 10,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Container(
                                    width: 100,
                                    height: 90,
                                  ),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.all(20),
                                elevation: 10,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Container(
                                    width: 100,
                                    height: 90,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ]);
                }

                return Column(
                  children: _createList(snapshot.data!['items']),
                );
              }),
        ),
      ),
    );
  }

  List<Widget> _createList(items) {
    List<Widget> lists = <Widget>[];
    if (items.length > 0) {
      for (dynamic data in items) {
        //print(data['media_gallery_entries']);
        lists.add(_buildCard(
          data,
        ));
      }
    } else {
      lists.add(const Center(child: Text('No se encontraron datos')));
    }
    return lists;
  }

  Widget _buildCard(data) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          data['media_gallery_entries'] != null &&
                  data['media_gallery_entries'].isNotEmpty
              ? Image.network(
                  _url + data['media_gallery_entries'][0]['file'],
                  width: double.infinity,
                  height: 180,
                )
              : Image.asset('assets/notFoundImg.png', width: 350, height: 180),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'reviews', arguments: data);
            },
            child: const Text('Ver Comentarios'),
          ),
        ],
      ),
    );
  }
}
