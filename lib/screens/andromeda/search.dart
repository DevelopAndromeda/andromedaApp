import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:andromeda/services/api.dart';

import 'package:andromeda/utilities/constanst.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  final search = TextEditingController();

  Future getRestaurantsSearch(input) async {
    //return await get('', 'integration',
    //    'products/?searchCriteria[filterGroups][0][filters][0][field]=name&searchCriteria[filterGroups][0][filters][0][value]=%25${input}%25&searchCriteria[filterGroups][0][filters][0][conditionType]=like&searchCriteria[sortOrders][0][field]=name&searchCriteria[sortOrders][0][direction]=ASC&searchCriteria[currentPage]=1&searchCriteria[pageSize]=20');
    return await get('', '', 'restaurant/product/search?q=$input');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 154, 126, 43),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                      //controller: search,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      placeholder: "Buscar",
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.search,
                          color: Color(0xff7b7b7b),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: const Color(0xfff7f7f7),
                          borderRadius: BorderRadius.circular(10)),
                      style: const TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontFamily: 'Exo Regular'),
                      onChanged: (value) async {
                        setState(() {
                          search.text = value;
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: (search.text.length >= 3)
          ? SingleChildScrollView(
              child: FutureBuilder(
                  future: getRestaurantsSearch(search.text),
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
                  },
                  initialData: const []),
            )
          : Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra verticalmente
                children: const [
                  Text('Ingresa datos para realizar una busqueda'),
                  SizedBox(height: 10), // Espacio entre los textos
                  Text('Nombre de restaurante'),
                  SizedBox(height: 10),
                  Text('Ciudad'),
                  SizedBox(height: 10),
                  Text('Tipo de restaurante'),
                ],
              ),
            ),
    );
  }

  List<Widget> _createList(items) {
    List<Widget> lists = <Widget>[];
    if (items.isEmpty) {
      lists.add(const Center(child: Text('Ingresa otros datos')));
      return lists;
    }
    items.forEach((element) => {lists.add(_buildCard(element))});
    return lists;
  }

  Widget _buildCard(data) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            'detail', arguments: data, (Route<dynamic> route) => false);
      },
      child: Card(
        color: Colors.black,
        elevation: 5.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getCustomAttribute(data['custom_attributes'], 'image') != ""
                ? Image.network(
                    pathMedia(
                      getCustomAttribute(data['custom_attributes'], 'image'),
                    ),
                    height: 150.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/notFoundImg.png',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Tipo de Comida: ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Horario de Atención: ',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
