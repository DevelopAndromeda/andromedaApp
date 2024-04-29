import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/Witgets/General/Colores_Base.dart';

class Restaurant {
  String nombre = '';
  String descripcion = '';
  String tipo = '';
  String direccion = '';
  //String diaDeLaSemana = 'Lunes';
  //String diaDeLaSemanaFin = 'Sábado';
  //List<Map<String, dynamic>> diasSemana = [];
}

class AltaRest extends StatefulWidget {
  const AltaRest({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AltaRestState createState() => _AltaRestState();
}

class _AltaRestState extends State<AltaRest> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  Restaurant _restaurant = Restaurant();
  final List<Map<String, dynamic>> _daysOfWeek = [
    {
      'name': 'Lunes',
      'checked': false,
      'index': 0,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Martes',
      'checked': false,
      'index': 1,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Miercoles',
      'checked': false,
      'index': 2,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Jueves',
      'checked': false,
      'index': 3,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Viernes',
      'checked': false,
      'index': 4,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Sabado',
      'checked': false,
      'index': 5,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Domingo',
      'checked': false,
      'index': 6,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    }
  ];

  List<String> _timeOptions = [
    '6:00 am',
    '7:00 am',
    '8:00 am',
    '9:00 am',
    '10:00 am',
    '11:00 am',
    '12:00 pm',
    '1:00 pm',
    '2:00 pm',
    '3:00 pm',
    '4:00 pm',
    '5:00 pm',
    '6:00 pm',
    '7:00 pm',
    '8:00 pm',
    '9:00 pm',
    '10:00 pm',
    '11:00 pm'
  ];

  Future<void> getUserData() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isNotEmpty) {
      print(sesion[0]);
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: Text('Alta de Restaurante'),
        centerTitle: true,
        leading: BackButton(),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                    controller: _nombreController,
                    decoration:
                        InputDecoration(labelText: 'Nombre del Restaurante'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del restaurante';
                      }
                      return null;
                    }),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _descripcionController,
                  decoration:
                      InputDecoration(labelText: 'Descripción del Restaurante'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la descripción del restaurante';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                    controller: _tipoController,
                    decoration:
                        InputDecoration(labelText: 'Tipo de Restaurante'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el tipo de restaurante';
                      }
                      return null;
                    }),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _direccionController,
                  decoration:
                      InputDecoration(labelText: 'Dirección del Restaurante'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la dirección del restaurante';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _daysOfWeek.length,
                        itemBuilder: (context, index) {
                          //var data = _daysOfWeek.toList();
                          //print(data[index]);
                          print(index);
                          print(_daysOfWeek[index]['name']);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _daysOfWeek[index]['checked'],
                                onChanged: (bool? value) {
                                  print(value);
                                  setState(() {
                                    _daysOfWeek[index]['checked'] = value;
                                  });
                                },
                              ),
                              Text(_daysOfWeek[index]['name']),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  //value: _daysOfWeek[index]['hora'][0]['from'],
                                  items: _timeOptions.map((String time) {
                                    return DropdownMenuItem<String>(
                                      value: time,
                                      child: Text(time),
                                    );
                                  }).toList(),
                                  decoration:
                                      InputDecoration(labelText: 'Inicio'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      // _restaurant.horaFin = newValue!;
                                      _daysOfWeek[index]['hora'][0]['from'] =
                                          newValue!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  //value: _restaurant.horaInicio,
                                  items: _timeOptions.map((String time) {
                                    return DropdownMenuItem<String>(
                                      value: time,
                                      child: Text(time),
                                    );
                                  }).toList(),
                                  decoration:
                                      InputDecoration(labelText: 'Final'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _daysOfWeek[index]['hora'][0]['to'] =
                                          newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final user = await serviceDB.instance
                            .getById('users', 'id_user', 1);
                        if (user.isEmpty) {
                          print('error user empty');
                          return;
                        }

                        Map<String, dynamic> arraSlot = {};
                        _daysOfWeek.forEach((element) {
                          if (element['checked'] == true) {
                            print(element);
                            //arraSlot[element['index'].toString()] =
                            arraSlot[element['index'].toString()] =
                                element['hora'];
                          }
                        });

                        Map<String, dynamic> ExtensionAttributes = {
                          'stock_item': {'qty': 99999999, 'is_in_stock': true},
                          'slot_data': arraSlot
                        };

                        List<Map<String, dynamic>> CustomAttributes = [];
                        CustomAttributes.addAll([
                          {
                            "attribute_code": "short_description",
                            "value": _descripcionController.text
                          },
                          {
                            "attribute_code": "cancellation_available",
                            "value": "1"
                          },
                          {"attribute_code": "no_of_guests", "value": "4"},
                          {"attribute_code": "max_capacity", "value": "4"},
                          {"attribute_code": "slot_duration", "value": "60"},
                          {
                            "attribute_code": "prevent_scheduling_before",
                            "value": "10"
                          },
                          {
                            "attribute_code": "break_time_bw_slot",
                            "value": "10"
                          },
                          {"attribute_code": "show_map_loction", "value": "1"},
                          {
                            'attribute_code': 'hotel_address',
                            'value': _direccionController.text
                          },
                          {"attribute_code": "hotel_country", "value": "MX"},
                          {"attribute_code": "hotel_state", "value": "955"},
                          {
                            "attribute_code": "location",
                            "value":
                                "De Los Ferrocarriles Sur, Norte, Puente de Ixtla, Mor., México"
                          },
                          {"attribute_code": "city", "value": "cancun"},
                          {
                            "attribute_code": "category_ids",
                            "value": ["6", "3"]
                          },
                          {
                            "attribute_code": "description",
                            "value": _descripcionController.text
                          },
                          {"attribute_code": "slot_for_all_days", "value": 0},
                          {
                            "attribute_code": "created_by",
                            "value": user[0]['id']
                          },
                          {
                            "attribute_code": "updated_by",
                            "value": user[0]['id']
                          }
                        ]);

                        Map<String, dynamic> producto = {
                          'product': {
                            'name': _nombreController.text,
                            'attribute_set_id': 13,
                            'sku': 'REST1991',
                            'price': 100,
                            'status': 1,
                            'visibility': 4,
                            'type_id': 'booking',
                            'extension_attributes': ExtensionAttributes,
                            'custom_attributes': CustomAttributes,
                          },
                          'saveOptions': true
                        };

                        final restaurante = await post(
                            '', 'integration', 'products', producto, 'v2');
                        print('rest --->');
                        print(restaurante);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Restaurante registrado correctamente'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Text('Registrar Restaurante'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "1", child: Text("Lunes")),
      const DropdownMenuItem(value: "2", child: Text("Martes")),
      const DropdownMenuItem(value: "3", child: Text("Miercoles")),
      const DropdownMenuItem(value: "4", child: Text("Jueves")),
      const DropdownMenuItem(value: "5", child: Text("Viernes")),
      const DropdownMenuItem(value: "6", child: Text("Sabado")),
      const DropdownMenuItem(value: "7", child: Text("Domingo")),
    ];
    return menuItems;
  }*/
}
