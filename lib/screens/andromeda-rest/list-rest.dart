import 'package:flutter/material.dart';
import 'package:andromeda/screens/andromeda-rest/modificacion-rest.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';
import 'package:andromeda/screens/andromeda-rest/menu.dart';

class ListRest extends StatefulWidget {
  const ListRest({super.key});

  @override
  State<ListRest> createState() => _ListRestState();
}

class _ListRestState extends State<ListRest> {
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
        title: Text('Retaurantes'),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
        print(data);
        lists.add(_buildCard(
          data,
        ));
      }
    } else {
      lists.add(Text('No se encontraron datos'));
    }
    return lists;
  }

  Widget _buildCard(data) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image(
            image: AssetImage('assets/image1.jpg'),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'modification', arguments: data);
            },
            child: Text('Modificación'),
          ),
        ],
      ),
    );
  }
}
