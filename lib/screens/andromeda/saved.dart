import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({super.key});

  @override
  State<MySavedPage> createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  Future getFavorites() async {
    final user = await serviceDB.instance.getById('users', 'id_user', 1);
    if (user.isEmpty) {
      return;
    }
    return await get(
      user[0]['token'],
      'custom',
      'wishlist/customer/items',
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
appBar: AppBar(
        title: Text('Guardado',
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold),),
        centerTitle: true,
      
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      
      ),

      body: _body(),
      bottomNavigationBar: MyBottomBar(
        index: 3,
      ),
    );
  }

  Stack _body() {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: getFavorites(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return Column(
                    children: _createList(snapshot.data!['data']),
                  );
                } else {
                  return const Text('Error en api');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _createList(items) {
    List<Widget> lists = <Widget>[];

    if (items.length > 0) {
      for (dynamic data in items) {
        lists.add(_buildCard(data));
      }
    } else {
      lists.add(const Center(child: Text('Sin Registros')));
    }

    return lists;
  }

  Widget _buildCard(data) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/notFoundImg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red, // Cambia el color del icono aquí
                    ),
                    onPressed: () async {
                      final user = await serviceDB.instance
                          .getById('users', 'id_user', 1);
                      if (user.isEmpty) {
                        return;
                      }
                      String token = user[0]['token'];
                      await delete(token, 'custom',
                          'wishlist/customer/item/${data['product_id']}');
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Se borro favorito')));
                    },
                  ),
                )
              ],
            ),
          ),
          Text(
            data['name'],
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'SKU: ${data['sku']}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
