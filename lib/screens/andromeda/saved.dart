import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({super.key});

  @override
  State<MySavedPage> createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  String? _url =
      "${dotenv.env['PROTOCOL']}://${dotenv.env['URL']}/media/catalog/product";

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
                  print(snapshot.data);
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
    if (items == null) {
      lists.add(const Center(child: Text('Tu Sesion a Expirado!')));
      return lists;
    }

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
            width: double.infinity,
            height: 150,
            decoration: getImg(
                data['images'] != null ? data['images'][0]['file'] : null),
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

  BoxDecoration getImg(String? img) {
    if (img != null) {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
              image: NetworkImage(_url! + img), fit: BoxFit.cover));
    } else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: const DecorationImage(
            image: AssetImage('assets/notFoundImg.png'),
            fit: BoxFit.cover,
          ));
    }
  }

  getCustomAttribute(data, type) {
    if (data.length == 0) {
      return '';
    }

    Map<String, String> typeValue = {'product_score': '0'};
    String? value = typeValue[type] ?? '';
    for (dynamic attr in data) {
      if (attr['attribute_code'] == type) {
        value = attr['value'];
      }
    }
    return value;
  }
}
