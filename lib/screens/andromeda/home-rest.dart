import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

class Restaurant {
  String nombre = '';
  String descripcion = '';
  String tipo = '';
  String direccion = '';
  String diaDeLaSemana = 'Lunes';
  String diaDeLaSemanaFin = 'Sábado';
  String horaInicio = '6:00 am';
  String horaFin = '11:00 pm';
}

class MyHomeRestPage extends StatefulWidget {
  const MyHomeRestPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomeRestPageState createState() => _MyHomeRestPageState();
}

class _MyHomeRestPageState extends State<MyHomeRestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  Restaurant _restaurant = Restaurant();
  /*List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];*/

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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        items: dropdownItems,
                        /*_daysOfWeek.map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),*/
                        decoration: InputDecoration(labelText: 'Día de Inicio'),
                        onChanged: (String? newValue) {
                          print(newValue);
                          setState(() {
                            _restaurant.diaDeLaSemana = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: DropdownButtonFormField(
                        items: dropdownItems,
                        /*_daysOfWeek.map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),*/
                        decoration: InputDecoration(labelText: 'Día de Fin'),
                        onChanged: (String? newValue) {
                          print(newValue);
                          setState(() {
                            _restaurant.diaDeLaSemanaFin = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text('Horario de Servicio:'),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _restaurant.horaInicio,
                        items: _timeOptions.map((String time) {
                          return DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Inicio'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _restaurant.horaInicio = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _restaurant.horaFin,
                        items: _timeOptions.map((String time) {
                          return DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Fin'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _restaurant.horaFin = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        List<Map<String, dynamic>> CustomAttributes = [];
                        Map<String, dynamic> arraSlot = {};
                        int inicio = int.parse(_restaurant.diaDeLaSemana);
                        int fin = int.parse(_restaurant.diaDeLaSemanaFin);

                        if (fin > inicio) {
                          int i = inicio;
                          while (i <= fin) {
                            arraSlot[i.toString()] = [
                              {
                                'from': _restaurant.horaInicio,
                                'to': _restaurant.horaFin
                              },
                            ];
                            i++;
                          }
                        } else if (fin < inicio) {
                          int i = inicio;
                          while (i != fin) {
                            if (i > 7) {
                              i = 0;
                            }
                            arraSlot[
                                i == 0 ? (i + 1).toString() : i.toString()] = [
                              {
                                'from': _restaurant.horaInicio,
                                'to': _restaurant.horaFin
                              },
                            ];

                            i++;
                          }
                        } else {
                          arraSlot[_restaurant.diaDeLaSemana] = [
                            {
                              'from': _restaurant.horaInicio,
                              'to': _restaurant.horaFin
                            },
                          ];
                        }
                        Map<String, dynamic> ExtensionAttributes = {
                          'stock_item': {'qty': 99999999, 'is_in_stock': true},
                          'slot_data': arraSlot
                        };
                        CustomAttributes.add({
                          "attribute_code": "short_description",
                          "value": _descripcionController.text
                        });
                        CustomAttributes.add({
                          'attribute_code': 'hotel_address',
                          'value': _direccionController.text
                        });

                        Map<String, dynamic> producto = {
                          'product': {
                            'name': _nombreController.text,
                            'attribute_set_id': 13,
                            'sku': 'RES12348',
                            'price': 100,
                            'status': 1,
                            'visibility': 4,
                            'type_id': 'booking',
                            'custom_attributes': CustomAttributes,
                            'extension_attributes': ExtensionAttributes
                          }
                        };

                        final user = await serviceDB.instance
                            .getById('users', 'id_user', 1);
                        if (user.isEmpty) {
                          return;
                        }

                        final restaurante = await post(
                            user[0]['token'], 'custom', 'products', producto);
                        print(restaurante);

                        /*print('Datos del restaurante:');
                        print('Nombre: ${_restaurant.nombre}');
                        print('Descripción: ${_restaurant.descripcion}');
                        print('Tipo: ${_restaurant.tipo}');
                        print('Dirección: ${_restaurant.direccion}');
                        print(
                            'Días de la semana abiertos: ${_restaurant.diaDeLaSemana} - ${_restaurant.diaDeLaSemanaFin}');
                        print('Hora de inicio: ${_restaurant.horaInicio}');
                        print('Hora de fin: ${_restaurant.horaFin}');*/
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Restaurante registrado correctamente'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Text('Registrar Restaurante'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await serviceDB.instance.deleteDatabase();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'start', (Route<dynamic> route) => false);
                    },
                    child: Text('Cerrar  Sesion'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
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
  }
}
