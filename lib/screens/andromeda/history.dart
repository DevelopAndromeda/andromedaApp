import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';
import 'package:shimmer/shimmer.dart';

import 'package:andromeda/services/db.dart';
import 'package:andromeda/services/api.dart';
import 'package:intl/intl.dart';
import 'package:andromeda/Witgets/LabelCard.dart';

import 'package:andromeda/utilities/constanst.dart';

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({Key? key}) : super(key: key);

  @override
  State<MyHistoryPage> createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  Future getHistory() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isEmpty) {
      return [];
    }

    return await get('', 'integration',
        'orders?searchCriteria[filterGroups][0][filters][0][field]=customer_id&searchCriteria[filterGroups][0][filters][0][value]=${sesion[0]['id']}&searchCriteria[filterGroups][0][filters][0][conditionType]=eq');
  }

  @override
  void initState() {
    super.initState();
    //getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
                future: getHistory(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    /*return const Center(
                      child: CircularProgressIndicator(),
                    );*/
                    return SizedBox(
                      width: double.infinity,
                      height: 100.0,
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  elevation: 10,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: Container(width: 100, height: 90),
                                  ),
                                ),
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  elevation: 10,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: Container(width: 100, height: 90),
                                  ),
                                ),
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  elevation: 10,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: Container(width: 100, height: 90),
                                  ),
                                ),
                                Card(
                                  margin: const EdgeInsets.all(5),
                                  elevation: 10,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: Container(width: 100, height: 90),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView(
                      padding: const EdgeInsets.all(5.0),
                      children: _createList(snapshot.data['items']),
                    );
                  } else {
                    return const Text('Error en api');
                  }
                }),
          ),
        ],
      ),
      bottomNavigationBar: const MyBottomBar(
        index: 1,
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    DateTime dateTimeWithTimeZone = DateTime.parse(data['date']);
    return InkWell(
      onTap: () {
        //print(data);
        /*Navigator.of(context).pushNamedAndRemoveUntil(
            data['ruta'], (Route<dynamic> route) => false);*/
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 10,
        child: SizedBox(
          width: 350,
          height: 150,
          child: Stack(
            children: <Widget>[
              // Imagen a la izquierda
              Positioned(
                left: 10,
                top: 15,
                bottom: 15,
                child: Container(
                    width: 100,
                    height: 90,
                    decoration: getImg(data['imagePath'])),
              ),

              // Título, descripción y número de personas a la derecha
              Positioned(
                left: 110,
                top: 10,
                right: 65,
                bottom: 5,
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
                        'Estado: ${data['status']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Fecha: ${DateFormat('dd/MM/yyyy').format(dateTimeWithTimeZone)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Cantidad de Personas: ${data["numberOfPeople"]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              // Botones de Modificar y Eliminar en la parte inferior derecha
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                      ),
                      // Espacio entre los botones
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 8, 8,
                                  8), // Cambia el color del icono aquí
                            ),
                            iconSize: 16,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Eliminar Reservación'),
                                    content: const Text(
                                        '¿Estás seguro de que quieres cancelar esta reservación?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(
                                            false), // No eliminar, cerrar diálogo
                                        child: const Text(
                                          'No',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await post(
                                              '',
                                              'integration',
                                              'orders/${data['id']}/cancel',
                                              {},
                                              '');

                                          Navigator.of(context).pop(
                                              true); // Eliminar, cerrar diálogo
                                        },
                                        child: const Text(
                                          'Sí',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).then((value) {
                                if (value == true) {
                                  setState(() {});
                                  responseSuccessWarning(
                                      context, 'Se Cancelo tu reservacion');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              //Etiqueta de estado
              LabelCard(
                  color: (data['status'] == 'complete'
                      ? Color.fromARGB(255, 48, 20, 233)
                      : data['status'] == 'pending'
                          ? Color.fromARGB(255, 241, 206, 10)
                          : Color.fromARGB(255, 235, 154, 148)) as Color,
                  title: data['status'])
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _createList(datas) {
    print(datas);
    List<Widget> lists = <Widget>[];
    if (datas.length == 0) {
      lists.add(const Center(
        child: Text("Aún no cuentas con historial para mostrar."),
      ));
      return lists;
    }
    for (dynamic data in datas) {
      //print('data');
      //print(data['items'][0]['extension_attributes']);
      lists.add(_buildCard({
        "id": data['items'][0]['order_id'],
        "title": data['items'][0]['name'],
        "ruta": "",
        "status": data['status'],
        "numberOfPeople": 0,
        "imagePath": data['items'][0]['extension_attributes'] != null
            ? data['items'][0]['extension_attributes']['image'][0]
            : null,
        "date": data['created_at'],
        "hora": ''
      }));
    }
    return lists;
  }

  BoxDecoration getImg(String? img) {
    if (img != null) {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
              image: NetworkImage(pathMedia(img)), fit: BoxFit.cover));
    } else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: const DecorationImage(
            image: AssetImage('assets/notFoundImg.png'),
            fit: BoxFit.cover,
          ));
    }
  }
}
