import 'dart:async';
import 'dart:convert';

import 'package:andromeda/models/estados.dart';
import 'package:andromeda/models/paises.dart';
import 'package:andromeda/models/ciudades.dart';
import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/models/categorias.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
//import "package:google_maps_webservice/geocoding.dart";
import 'package:andromeda/screens/andromeda-rest/menu.dart';

class ModificacionRestaurante extends StatefulWidget {
  const ModificacionRestaurante({super.key, required this.data});
  final Map<dynamic, dynamic> data;

  @override
  _ModificacionRestaurante createState() => _ModificacionRestaurante();
}

class _ModificacionRestaurante extends State<ModificacionRestaurante> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _numberPhone = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _no_of_guests = TextEditingController();
  final TextEditingController _max_capacity = TextEditingController();
  final TextEditingController _slot_duration = TextEditingController();
  final TextEditingController _prevent_scheduling_before =
      TextEditingController();
  List<Categoria> _selectedCategorias = [];
  final TextEditingController _break_time_bw_slot = TextEditingController();
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(23.3231416, -103.8384764));
  Completer<GoogleMapController> _controller = Completer();
  final List<Map<String, dynamic>> _daysOfWeek = [
    {
      'name': 'Lunes',
      'checked': false,
      'index': 1,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Martes',
      'checked': false,
      'index': 2,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Miercoles',
      'checked': false,
      'index': 3,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Jueves',
      'checked': false,
      'index': 4,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Viernes',
      'checked': false,
      'index': 5,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Sabado',
      'checked': false,
      'index': 6,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Domingo',
      'checked': false,
      'index': 7,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    }
  ];

  late Future<List<Pais>> futurePais;
  Pais? _selectedPais;

  Future<List<Estado>>? futureEstado;
  Estado? _selectedEstado;

  Future<List<Ciudad>>? futureCiudad;
  Ciudad? _selectedCiudad;

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
  List<Categoria> _categoria = [];
  List<String> _finalCategories = [];

  Future<void> getUserData() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isNotEmpty) {
      //print('sesion');
      //print(sesion[0]);
      if (sesion[0]['lat'] == null || sesion[0]['long'] == null) {
        _setCoords();
      } else {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(sesion[0]['lat'], sesion[0]['long']), 15));
      }
    }
  }

  Future<void> _setCoords() async {
    dynamic geo = await determinePosition();
    //print('geo');
    //print(geo);
    Map<String, dynamic> _update = {'lat': geo.longitude, 'long': geo.latitude};
    await serviceDB.instance.updateRecord('users', _update, 'id_user', 1);

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(geo.longitude, geo.latitude), 15));
  }

  Future<void> getCategories() async {
    final categories = await get('', 'integration',
        'categories/list?searchCriteria[filterGroups][0][filters][1][field]=is_visible_app&searchCriteria[filterGroups][0][filters][1][value]=1&searchCriteria[filterGroups][0][filters][1][conditionType]=eq&searchCriteria[sortOrders][0][field]=name&searchCriteria[sortOrders][0][direction]=ASC');
    if (categories.isNotEmpty) {
      categories['items'].forEach((element) {
        _categoria.add(Categoria(id: element['id'], name: element['name']));
      });
      setState(() {});
    }
  }

  Future<List<Pais>> fetchPaises() async {
    final responseJson = json.decode("""
    {
      "data": [
        {
          "id": "1",
          "name": "México",
          "code": "MX"
        }
      ]
    }
    """);

    /*responseJson['data'].forEach((data) {
      print('data');
      print(getCustomAttribute(
          widget.data['custom_attributes'], 'hotel_country'));
      print(data);
      print(data['code']);
      if (getCustomAttribute(
              widget.data['custom_attributes'], 'hotel_country') ==
          data['code']) {
        _selectedPais = Pais.fromJson(data);
      }
    });*/

    return (responseJson['data'] as List)
        .map((data) => Pais.fromJson(data))
        .toList();
  }

  Future<List<Estado>> fetchEstados() async {
    //Llenar base de datos local
    final responseJson =
        await get('', '', 'states?countryCode=${_selectedPais?.code}');
    if (responseJson == null) {
      //print('no hay datos en endpoint');
      return [];
    }

    return (responseJson['items'] as List)
        .map((data) => Estado.fromJson(data))
        .toList();
  }

  Future<List<Ciudad>> fetchCiudades() async {
    final responseJson = await get(
        '', 'integration', 'product/cities?search=${_selectedEstado?.code}');
    if (responseJson == null) {
      //print('no hay datos en endpoint');
      return [];
    }

    return (responseJson['items'] as List)
        .map((data) => Ciudad.fromJson(data))
        .toList();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  setData() {
    print(widget.data);
    _nombreController.text = widget.data['name'];
    _descripcionController.text = getCustomAttribute(
        widget.data['custom_attributes'], 'short_description');
    _no_of_guests.text =
        getCustomAttribute(widget.data['custom_attributes'], '_no_of_guests');
    _max_capacity.text =
        getCustomAttribute(widget.data['custom_attributes'], 'max_capacity');
    _slot_duration.text =
        getCustomAttribute(widget.data['custom_attributes'], 'slot_duration');
    _prevent_scheduling_before.text = getCustomAttribute(
        widget.data['custom_attributes'], 'prevent_scheduling_before');
    _numberPhone.text = getCustomAttribute(
        widget.data['custom_attributes'], 'restaurant_number');

    //getCustomAttribute(widget.data['custom_attributes'], 'hotel_country')
    /*futurePais.map((data) {
      print('data');
      print(data);
      print(code);
      if (data['code'] == code) {
        _selectedPais = Pais.fromJson(data);
      }
    });*/
    //setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    futurePais = fetchPaises();
    setData();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(changeSalida: () {}),
      appBar: AppBar(
        title: Text('Modificacion'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                SizedBox(height: 20.0),
                MultiSelectBottomSheetField(
                  initialChildSize: 0.4,
                  listType: MultiSelectListType.CHIP,
                  searchable: true,
                  buttonText: Text("Tipo de Restaurantes"),
                  title: Text("Categorias"),
                  items: _categoria
                      .map((cat) => MultiSelectItem<Categoria>(cat, cat.name))
                      .toList(),
                  onConfirm: (values) {
                    //_selectedCategorias = values!;
                    print('onConfirm');
                    print(values);
                    for (dynamic element in values) {
                      print(element.id);
                      _finalCategories.add(element.id.toString());
                    }
                    /*values.forEach((element) {
                      print(element?.id);
                    });*/
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      print('onTap');
                      print(value);
                      /*setState(() {
                            _selectedCategorias.remove(value);
                          });*/
                    },
                  ),
                ),
                _selectedCategorias == null || _selectedCategorias.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "None selected",
                          style: TextStyle(color: Colors.black54),
                        ))
                    : Container(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Informacion de Contacto',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                    controller: _numberPhone,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Telefono'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el Telefono de contacto';
                      }
                      return null;
                    }),
                SizedBox(height: 10.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: FutureBuilder<List<Pais>>(
                    future: futurePais,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //return Text('aa');
                        return DropdownButton(
                          value: _selectedPais,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (Pais? newValue) {
                            print(newValue);
                            setState(() {
                              _selectedPais = newValue as Pais;
                              futureEstado = fetchEstados();
                            });
                          },
                          items: snapshot.data
                              ?.map<DropdownMenuItem<Pais>>((Pais value) {
                            return DropdownMenuItem<Pais>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: FutureBuilder<List<Estado>>(
                    future: futureEstado,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButton(
                          value: _selectedEstado,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (Estado? newValue) {
                            print(newValue);
                            setState(() {
                              _selectedEstado = newValue as Estado;
                              futureCiudad = fetchCiudades();
                            });
                          },
                          items: snapshot.data
                              ?.map<DropdownMenuItem<Estado>>((Estado value) {
                            return DropdownMenuItem<Estado>(
                              value: value,
                              child: Text(value.label),
                            );
                          }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Text('Seleccione Pais');
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: FutureBuilder<List<Ciudad>>(
                    future: futureCiudad,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButton(
                          value: _selectedCiudad,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          onChanged: (Ciudad? newValue) {
                            print(newValue);
                            setState(() {
                              _selectedCiudad = newValue as Ciudad;
                            });
                          },
                          items: snapshot.data
                              ?.map<DropdownMenuItem<Ciudad>>((Ciudad value) {
                            return DropdownMenuItem<Ciudad>(
                              value: value,
                              child: Text(value.statecity),
                            );
                          }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Text('Seleccion Estado');
                    },
                  ),
                ),
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
                  onChanged: (value) async {
                    //print('este valor ira al api de mapas: $value');
                    if (value.length > 4) {
                      //print('ir geo');
                      final data = await getDirByGeocoding(value);
                      print(data);
                      //GeocodingResponse response =
                      //    await geocoding.searchByAddress(value);
                      //print(response);
                    }
                  },
                ),
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _initialPosition,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Informacion de Reserva',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 10.0),
                Row(children: <Widget>[
                  Flexible(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: TextFormField(
                        controller: _max_capacity,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Capacidad Maxima',
                            hintText: 'Capacidad Maxima'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese Capacidad Maxima';
                          }
                          return null;
                        }),
                  )),
                  Flexible(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: TextFormField(
                        controller: _slot_duration,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Duracion',
                            hintText: 'Ingrese Tiempo'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese Tiempo';
                          }
                          return null;
                        }),
                  )),
                ]),
                Row(children: <Widget>[
                  Flexible(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: TextFormField(
                        controller: _prevent_scheduling_before,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tiempo de Descanso',
                            hintText: 'Tiempo de Descanso'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese Tiempo de Descanso';
                          }
                          return null;
                        }),
                  )),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: TextFormField(
                        controller: _break_time_bw_slot,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Prgramacion',
                            hintText: 'Evitar Prgramacion'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese Tiempo';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 10.0),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 380,
                    width: double.infinity,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _daysOfWeek.length,
                        itemBuilder: (context, index) {
                          //var data = _daysOfWeek.toList();
                          //print(data[index]);
                          //print(index);
                          //print(_daysOfWeek[index]['name']);
                          return Column(
                            children: [
                              Container(
                                //color: Colors.blue,
                                child: Row(children: [
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
                                ]),
                              ),
                              Container(
                                //color: Colors.red,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 2),
                                        child: DropdownButtonFormField<String>(
                                          //value: _daysOfWeek[index]['hora'][0]['from'],
                                          items:
                                              _timeOptions.map((String time) {
                                            return DropdownMenuItem<String>(
                                              value: time,
                                              child: Text(time),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                              labelText: 'Inicio'),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              // _restaurant.horaFin = newValue!;
                                              _daysOfWeek[index]['hora'][0]
                                                  ['from'] = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 2),
                                        child: DropdownButtonFormField<String>(
                                          //value: _restaurant.horaInicio,
                                          items:
                                              _timeOptions.map((String time) {
                                            return DropdownMenuItem<String>(
                                              value: time,
                                              child: Text(time),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                              labelText: 'Final'),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _daysOfWeek[index]['hora'][0]
                                                  ['to'] = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
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
                          {
                            "attribute_code": "no_of_guests",
                            "value": _no_of_guests.text
                          },
                          {
                            "attribute_code": "max_capacity",
                            "value": _max_capacity.text
                          },
                          {
                            "attribute_code": "slot_duration",
                            "value": _slot_duration.text
                          },
                          {
                            "attribute_code": "prevent_scheduling_before",
                            "value": _prevent_scheduling_before.text
                          },
                          {
                            "attribute_code": "break_time_bw_slot",
                            "value": _break_time_bw_slot.text
                          },
                          {"attribute_code": "show_map_loction", "value": "1"},
                          {
                            'attribute_code': 'hotel_address',
                            'value': _direccionController.text
                          },
                          {
                            "attribute_code": "hotel_country",
                            "value": _selectedPais?.code
                          },
                          {
                            "attribute_code": "hotel_state",
                            "value": _selectedEstado?.label
                          },
                          {
                            "attribute_code": "location",
                            "value":
                                "De Los Ferrocarriles Sur, Norte, Puente de Ixtla, ${_selectedEstado?.label}., ${_selectedPais?.name}"
                          },
                          {
                            "attribute_code": "city",
                            "value": _selectedCiudad?.statecity
                          },
                          {
                            "attribute_code": "category_ids",
                            "value": _finalCategories
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
                          },
                          {
                            "attribute_code": "product_city",
                            "value": _selectedCiudad?.statecity
                          },
                          {
                            "attribute_code": "restaurant_number",
                            "value": _numberPhone.text
                          },
                        ]);

                        Map<String, dynamic> producto = {
                          'product': {
                            'name': _nombreController.text,
                            'attribute_set_id': 13,
                            'sku': _nombreController.text,
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
                                Text('Restaurante actualizado correctamente'),
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
