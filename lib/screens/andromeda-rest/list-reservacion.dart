import 'package:flutter/material.dart';

import 'package:andromeda/services/db.dart';
import 'package:andromeda/services/api.dart';

import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/Witgets/LabelCard.dart';
import 'package:andromeda/screens/andromeda-rest/menu.dart';
import 'package:intl/intl.dart';

class listReservacion extends StatefulWidget {
  const listReservacion({super.key});

  @override
  State<listReservacion> createState() => _listReservacionState();
}

class _listReservacionState extends State<listReservacion> {
  Future getHistory() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isEmpty) {
      return [];
    }

    return await get(sesion[0]['token'], 'custom',
        'mysalesorders?searchCriteria[currentPage]=1&searchCriteria[pageSize]=10');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(changeSalida: () {}),
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: Text('Reservaciones'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: getHistory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(5.0),
              children: _createList(snapshot.data['data']['data']),
            );
          } else {
            return const Text('Error en api');
          }
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    DateTime dateTimeWithTimeZone = DateTime.parse(data['date']);
    return InkWell(
      onTap: () {
        print(data);
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
                        'Cliente: ${data['title']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Estado: ${data['status']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Fecha: ${DateFormat('dd/MM/yyyy').format(dateTimeWithTimeZone)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Hora: ${data['hora']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              // Botones de Modificar y Eliminar en la parte inferior derecha

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
    print('_createList');
    List<Widget> lists = <Widget>[];
    if (datas.length == 0) {
      lists.add(Center(
        child: Text("Aún no cuentas con historial para mostrar."),
      ));
      return lists;
    }
    for (dynamic data in datas) {
      lists.add(_buildCard({
        "title": data['billing_firstname'] ?? '',
        "ruta": "",
        "status": data['status'] ?? '',
        "date": data['product_options']['info_buyRequest']['booking_date']
                .split('/')
                .reversed
                .join('-') ??
            '',
        "hora": data['product_options']['info_buyRequest']['booking_time'] ?? ''
      }));
    }
    return lists;
  }
}
