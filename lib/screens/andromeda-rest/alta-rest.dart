import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/models/estados.dart';
import 'package:andromeda/models/paises.dart';
import 'package:andromeda/models/ciudades.dart';
import 'package:andromeda/models/categorias.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/screens/andromeda-rest/menu.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

//import "package:google_maps_webservice/geocoding.dart";

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
  final TextEditingController _numberPhone = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _no_of_guests = TextEditingController();
  final TextEditingController _max_capacity = TextEditingController();
  final TextEditingController _slot_duration = TextEditingController();
  final TextEditingController _prevent_scheduling_before =
      TextEditingController();
  final TextEditingController _nombreMesa = TextEditingController();
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

  final List<String> _timeOptions = [
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
  List<Categoria> _tiposRest = [];
  List<int> tiposRest = [4, 16, 42, 71, 72, 73, 75, 76, 77, 78, 79, 80];
  Categoria? _selectedTipoRest;
  Uint8List? _image;
  List<File> arrayFiles = <File>[];
  final List<Map<String, dynamic>> mesas = [
    {
      'nombre': 'NOMBRE',
      'accion': 'ACCION',
    }
  ];
  //List<String> Paises = ['México'];
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
            LatLng(double.parse(sesion[0]['lat']),
                double.parse(sesion[0]['long'])),
            15));
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
        /*for (int value in tiposRest) {
          print('aca toy');
          print(value);
          print(element['id']);
          if (value == element['id']) {
            _tiposRest.add(Categoria(id: element['id'], name: element['name']));
            break;
          }
        }
        _categoria.add(Categoria(id: element['id'], name: element['name']));*/
        //print(tiposRest.contains(element['id']));
        if (tiposRest.contains(element['id'])) {
          _tiposRest.add(Categoria(id: element['id'], name: element['name']));
        } else {
          _categoria.add(Categoria(id: element['id'], name: element['name']));
        }
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

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      arrayFiles.add(File(returnImage.path));
      //selectedIMage = File(returnImage.path);
      //_image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop(); //close the model sheet
  }

  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      arrayFiles.add(File(returnImage.path));
      //selectedIMage = File(returnImage.path);
      //_image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    futurePais = fetchPaises();
    //futureEstado = [] as Future<List<Estado>>?;
    //futureCiudad = [] as Future<List<Ciudad>>?;
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(changeSalida: () {}),
        appBar: AppBar(
          title: const Text(
            'Alta',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: _body());
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.blue[100],
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void deleteImage(index) async {
    setState(() {
      arrayFiles.removeAt(index);
    });
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Restaurante',
                  labelStyle: TextStyle(color: Colors.black), // Etiqueta negra
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                ),
                style: const TextStyle(color: Colors.black), // Texto negro
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del restaurante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del Restaurante',
                  labelStyle: TextStyle(color: Colors.black), // Etiqueta negra
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                ),
                style: const TextStyle(color: Colors.black), // Texto negro
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción del restaurante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                child: DropdownButtonFormField<Categoria>(
                  // Cambiado a DropdownButtonFormField
                  value: _selectedTipoRest,
                  icon: const Icon(Icons.arrow_downward,
                      color: Colors.black), // Icono negro
                  elevation: 0, // Sin elevación (sombra)
                  style: const TextStyle(color: Colors.black), // Texto negro
                  decoration: const InputDecoration(
                    // Decoración personalizada
                    labelText:
                        'Selecciona una categoría', // Etiqueta (opcional)
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black, width: 2.0), // Borde negro 2px
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black, width: 2.0), // Borde negro 2px
                    ),
                    border: OutlineInputBorder(
                      // Borde cuando está abierto
                      borderSide: BorderSide(
                          color: Colors.black, width: 2.0), // Borde negro 2px
                    ),
                  ),
                  onChanged: (Categoria? value) {
                    setState(() {
                      _selectedTipoRest = value!;
                      _finalCategories.add(value.id.toString());
                    });
                  },
                  items: _tiposRest
                      .map<DropdownMenuItem<Categoria>>((Categoria value) {
                    return DropdownMenuItem<Categoria>(
                      value: value,
                      child: Text(value.name,
                          style: TextStyle(color: Colors.black)), // Texto negro
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10.0),
              MultiSelectBottomSheetField(
                initialChildSize: 0.4,
                listType: MultiSelectListType.CHIP,
                searchable: true,
                buttonText: const Text(
                  "Tipo de Comida",
                  style: TextStyle(color: Colors.black),
                ),
                buttonIcon: const Icon(Icons.arrow_drop_down,
                    color: Colors.black), // Ícono opcional
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.zero, // Opcional
                ),
                title: const Text(
                  "Categorias",
                  style: TextStyle(color: Colors.black),
                ),
                items: _categoria
                    .map((cat) => MultiSelectItem<Categoria>(cat, cat.name))
                    .toList(),
                onConfirm: (values) {
                  //_selectedCategorias.add(value);
                  _finalCategories = [];
                  for (dynamic element in values) {
                    _finalCategories.add(element.id.toString());
                  }
                  setState(() {});
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {},
                  chipColor: Colors.black, // Fondo de chip en negro
                  textStyle:
                      TextStyle(color: Colors.white), // Texto de chip en blanco
                ),
                selectedItemsTextStyle: const TextStyle(color: Colors.black),
                itemsTextStyle: const TextStyle(color: Colors.black),
              ),
              _finalCategories.length < 1
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "None selected",
                        style: TextStyle(color: Colors.black54),
                      ))
                  : Container(),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Informacion de Contacto',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _numberPhone,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  labelStyle: TextStyle(
                      color: Colors.black), // Etiqueta negra (opcional)
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el Teléfono de contacto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                child: FutureBuilder<List<Pais>>(
                  future: futurePais,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButtonFormField<Pais>(
                        value: _selectedPais,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        iconSize: 30,
                        elevation: 0,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero, // Sin redondeles
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero, // Sin redondeles
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero, // Sin redondeles
                          ),
                        ),
                        onChanged: (Pais? newValue) {
                          setState(() {
                            _selectedPais = newValue as Pais;
                            futureEstado = fetchEstados();
                          });
                        },
                        items: snapshot.data
                            ?.map<DropdownMenuItem<Pais>>((Pais value) {
                          return DropdownMenuItem<Pais>(
                            value: value,
                            child: Text(value.name,
                                style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                child: FutureBuilder<List<Estado>>(
                  future: futureEstado,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButtonFormField<Estado>(
                        // Cambiado a DropdownButtonFormField
                        value: _selectedEstado,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        iconSize: 30,
                        elevation: 0, // Eliminar elevación (sombra)
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero, // Redondeles en 0
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero, // Redondeles en 0
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero, // Redondeles en 0
                          ),
                        ),
                        onChanged: (Estado? newValue) {
                          setState(() {
                            _selectedEstado = newValue as Estado;
                            futureCiudad = fetchCiudades();
                          });
                        },
                        items: snapshot.data
                            ?.map<DropdownMenuItem<Estado>>((Estado value) {
                          return DropdownMenuItem<Estado>(
                            value: value,
                            child: Text(value.label,
                                style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Text('Seleccione Pais',
                        style: TextStyle(color: Colors.black)); // Texto negro
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                child: FutureBuilder<List<Ciudad>>(
                  future: futureCiudad,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButtonFormField<Ciudad>(
                        value: _selectedCiudad,
                        icon: const Padding(
                          padding: EdgeInsets.only(
                              left: -0.0), // Mueve el icono 10px a la izquierda
                          child:
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                        ),
                        iconSize: 30,
                        elevation: 0,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero,
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.zero,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16), // Ajusta estos valores
                        ),
                        onChanged: (Ciudad? newValue) {
                          setState(() {
                            _selectedCiudad = newValue as Ciudad;
                          });
                        },
                        items: snapshot.data
                            ?.map<DropdownMenuItem<Ciudad>>((Ciudad value) {
                          return DropdownMenuItem<Ciudad>(
                            value: value,
                            child: Text(value.statecity,
                                style: const TextStyle(
                                    color: Colors.black)), // Texto negro
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Text('Seleccione Estado',
                        style: TextStyle(color: Colors.black)); // Texto negro
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección del Restaurante',
                  labelStyle: TextStyle(
                      color: Colors.black), // Etiqueta negra (opcional)
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2.0), // Borde negro de 2px
                    borderRadius: BorderRadius.zero, // Sin redondeles
                  ),
                ),
                style: const TextStyle(
                    color: Colors.black), // Texto negro (opcional)
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección del restaurante';
                  }
                  return null;
                },
                onChanged: (value) async {
                  if (value.length > 4) {
                    final data = await getDirByGeocoding(value);
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 300,
                child: GoogleMap(
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialPosition,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Informacion de Reserva',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 10.0),
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
                          labelText: 'Aforo Maximo',
                          hintText: 'Aforo Maximo'),
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
                          labelText: 'Duracion por reserva',
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
                /*Flexible(
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
                  )),*/
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: TextFormField(
                      controller: _break_time_bw_slot,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Reservar antes de...',
                          hintText: 'Min'),
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
              const SizedBox(height: 10.0),
              const Text(
                'Informacion de Zona',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                  controller: _nombreMesa,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la zona')),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  onPressed: () {
                    agregarMesa();
                  },
                  child: Text(
                    'Agregar Zona',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 10.0),
              mesas.length == 1
                  ? const Center(child: Text('Sin zonas registradas'))
                  : _table(),
              const SizedBox(height: 20.0),
              const Text(
                'Informacion de Servicio',
                style: TextStyle(fontSize: 25),
              ),
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
                            SizedBox(
                              //color: Colors.blue,
                              child: Row(children: [
                                Checkbox(
                                  value: _daysOfWeek[index]['checked'],
                                  onChanged: (bool? value) {
                                    //print(value);
                                    setState(() {
                                      _daysOfWeek[index]['checked'] = value;
                                    });
                                  },
                                ),
                                Text(_daysOfWeek[index]['name']),
                              ]),
                            ),
                            SizedBox(
                              //color: Colors.red,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 2),
                                      child: SizedBox(
                                        width: 150, // Ajusta el ancho deseado
                                        child: DropdownButtonFormField<String>(
                                          //value: _daysOfWeek[index]['hora'][0]['from'],
                                          items:
                                              _timeOptions.map((String time) {
                                            return DropdownMenuItem<String>(
                                              value: time,
                                              child: Text(time),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            labelText: 'Inicio',
                                            labelStyle: TextStyle(
                                                color: Colors
                                                    .black), // Etiqueta negra
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0), // Borde negro
                                              borderRadius: BorderRadius
                                                  .zero, // Sin redondeles
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0), // Borde negro
                                              borderRadius: BorderRadius
                                                  .zero, // Sin redondeles
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0), // Borde negro
                                              borderRadius: BorderRadius
                                                  .zero, // Sin redondeles
                                            ),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              // _restaurant.horaFin = newValue!;
                                              _daysOfWeek[index]['hora'][0]
                                                  ['from'] = newValue!;
                                            });
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 2),
                                      child: SizedBox(
                                        // Limitamos el ancho del DropdownButtonFormField
                                        width:
                                            150, // Ajusta este valor según tus necesidades
                                        child: DropdownButtonFormField<String>(
                                          //value: _restaurant.horaInicio,
                                          items:
                                              _timeOptions.map((String time) {
                                            return DropdownMenuItem<String>(
                                              value: time,
                                              child: Text(time),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            labelText: 'Final',
                                            labelStyle: TextStyle(
                                                color: Colors
                                                    .black), // Etiqueta negra
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0), // Borde negro
                                              borderRadius: BorderRadius
                                                  .zero, // Sin redondeles
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0), // Borde negro
                                              borderRadius: BorderRadius
                                                  .zero, // Sin redondeles
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0), // Borde negro
                                              borderRadius: BorderRadius
                                                  .zero, // Sin redondeles
                                            ),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _daysOfWeek[index]['hora'][0]
                                                  ['to'] = newValue!;
                                            });
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        );
                      }),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Foto Galeria',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                onPressed: () async {
                  showImagePickerOption(context);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Seleccionar Foto'),
              ),
              SizedBox(
                height: 300,
                width: 250,
                child: ListView.builder(
                  itemCount: arrayFiles.length,
                  itemBuilder: (context, index) {
                    if (arrayFiles.length < 1) {
                      return Center(
                        child: Text('sin imagenes para mostrar'),
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          Image.file(arrayFiles[index],
                              height: 200, width: 250, fit: BoxFit.fitWidth),
                          GestureDetector(
                            onTap: () => deleteImage(index),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final user = await serviceDB.instance
                          .getById('users', 'id_user', 1);
                      if (user.isEmpty) {
                        //print('error user empty');
                        return;
                      }

                      Map<String, dynamic> arraSlot = {};
                      _daysOfWeek.forEach((element) {
                        if (element['checked'] == true) {
                          //print(element);
                          //arraSlot[element['index'].toString()] =
                          arraSlot[element['index'].toString()] =
                              element['hora'];
                        }
                      });

                      Map<String, dynamic> extensionAttributes = {
                        'stock_item': {'qty': 99999999, 'is_in_stock': true},
                        'slot_data': arraSlot
                      };

                      List<Map<String, dynamic>> customAttributes = [];
                      customAttributes.addAll([
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
                              "${_direccionController.text}, ${_selectedEstado?.label}., ${_selectedPais?.name}"
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

                      List<Map<String, dynamic>> options = [];
                      Map<String, dynamic> table = {
                        "title": "Zona",
                        "type": "drop_down",
                        "sort_order": 1,
                        "is_require": true,
                        "product_sku": _nombreController.text,
                        "values": []
                      };
                      options.add(table);

                      int indice = 0;
                      for (dynamic data in mesas) {
                        //print('data');
                        //print(data);

                        if (data['nombre'] != 'NOMBRE') {
                          table['values'].add({
                            "title": data['nombre'],
                            "price": 0,
                            "price_type": "fixed",
                            "sku": data['nombre'],
                            "sort_order": indice
                          });
                        }
                        indice++;
                      }

                      //print(table);
                      //print(options);

                      Map<String, dynamic> producto = {
                        'product': {
                          'name': _nombreController.text,
                          'attribute_set_id': 13,
                          'sku': _nombreController.text,
                          'price': 100,
                          'status': 0,
                          'visibility': 4,
                          'type_id': 'booking',
                          'extension_attributes': extensionAttributes,
                          'custom_attributes': customAttributes,
                          'options': options
                        },
                        'saveOptions': true
                      };

                      final restaurante = await post(
                          '', 'integration', 'products', producto, 'v2');
                      //print('rest --->');
                      //print(restaurante);
                      responseSuccessWarning(
                          context, 'Restaurante registrado correctamente');

                      int position = 1;
                      arrayFiles.forEach((element) async {
                        final bytes = File(element.path).readAsBytesSync();
                        String img64 = base64Encode(bytes);

                        var img = {
                          "entry": [
                            {
                              "media_type": "image",
                              "label":
                                  "img_${_nombreController.text}_$position",
                              "position": position,
                              "disabled": false,
                              "types": ["image", "small_image", "thumbnail"],
                              "content": {
                                "base64_encoded_data": img64,
                                "type": "image/jpeg",
                                "name":
                                    "img_${_nombreController.text}_$position.jpg"
                              }
                            }
                          ]
                        };

                        await post(
                            '',
                            'integration',
                            'products/${_nombreController.text}/media',
                            img,
                            'V2');

                        position++;
                      });
                    } catch (e) {
                      responseErrorWarning(context, e.toString());
                      //print(e);
                    }
                  }
                },
                child: Text(
                  'Registrar Restaurante',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  agregarMesa() {
    if (_nombreMesa.text == '') {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    mesas.add({'nombre': _nombreMesa.text});
    setState(() {
      _nombreMesa.text = '';
    });
  }

  SingleChildScrollView _table() {
    return SingleChildScrollView(
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: mesas.length,
            itemBuilder: (context, index) {
              return tr(index);
            }),
      ),
    );
  }

  Row tr(int index) {
    var id = index == 0 ? '#' : index;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(child: Text("$id")),
        Flexible(child: Text("${mesas[index]['nombre']}")),
        Flexible(
            child: index == 0
                ? Text("${mesas[index]['accion']}")
                : IconButton(
                    onPressed: () {
                      mesas.removeAt(index);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete))),
        //Flexible(child: Text("${mesas[index]['pago']}")),
        //Flexible(child: Text("${mesas[index]['total']}"))
      ],
    );
  }
}
