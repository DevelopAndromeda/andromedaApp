import 'package:appandromeda/witgets/screens/not_search_results.dart';
import 'package:flutter/material.dart';
import 'package:appandromeda/witgets/Colores_Base.dart';
import 'package:appandromeda/services/api.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key, required this.data});
  final Map<dynamic, dynamic> data;

  @override
  State<Reviews> createState() => _Reviews();
}

class _Reviews extends State<Reviews> {
  final int _status = 2;

  Future getReviews() async {
    return await get('', 'integration',
        'reviews?searchCriteria[filterGroups][0][filters][0][field]=entity_pk_value&searchCriteria[filterGroups][0][filters][0][value]=${widget.data['id']}&searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[filterGroups][1][filters][0][field]=status_id&searchCriteria[filterGroups][1][filters][0][conditionType]=eq&searchCriteria[filterGroups][1][filters][0][value]=$_status');
  }

  setNewState(data, int status) async {
    Map<String, dynamic> review = {
      "review": {
        "title": data['title'],
        "detail": data['detail'],
        "nickname": data['nickname'],
        "review_entity": data['review_entity'],
        "review_status": status,
        "entity_pk_value": data['entity_pk_value'],
        "ratings": data['ratings']
      }
    };

    await put('', 'integration', 'reviews/', review, data['id'].toString());
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Se actualizo la Review')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: const Text(
          'Review Pendientes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(
          onPressed: () => Navigator.pushNamed(context, 'list-reviews'),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getReviews(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                //print('snapshot.data');
                //print(snapshot.data);

                if (snapshot.hasData) {
                  return Column(
                    children: _createList(snapshot.data!['items']),
                  );
                } else {
                  return const Text('Error en api');
                }
              }),
        ),
      ),
    );
  }

  List<Widget> _createList(items) {
    List<Widget> lists = <Widget>[];
    if (items.length > 0) {
      for (dynamic data in items) {
        lists.add(_buildCard(data));
      }
    } else {
      lists.add(NotSearchResults(img: "Review_restaurantero.png"));
    }
    return lists;
  }

  Widget _buildCard(data) {
    //print('_buildCard');
    //print(data);
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 10,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Stack(
          children: <Widget>[
            // Título, descripción y número de personas a la derecha
            Positioned(
              left: 60,
              top: 10,
              right: 60,
              bottom: 10,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Nickname: ${data['nickname']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data["detail"],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}