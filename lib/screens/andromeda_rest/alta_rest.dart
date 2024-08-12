import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:andromeda/geocoding/geocoding_result.dart';
import 'package:andromeda/services/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/models/estados.dart';
import 'package:andromeda/models/paises.dart';
import 'package:andromeda/models/ciudades.dart';
import 'package:andromeda/models/categorias.dart';

import 'package:andromeda/services/catalog.dart';
import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:camera/camera.dart';
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
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tablesByRestaurantController =
      TextEditingController();
  final TextEditingController _numberPhone = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _maxCapacity = TextEditingController();
  final TextEditingController _slotDuration = TextEditingController();
  final TextEditingController _preventSchedulingBefore =
      TextEditingController();
  final TextEditingController _nombreMesa = TextEditingController();
  final TextEditingController _breakTimeBwSlot = TextEditingController();
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(23.3231416, -103.8384764));
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _marker = const LatLng(0, -0);
  bool banderaMarket = false;
  final CatalogService _catalogService = CatalogService();

  final Geocoding _geocoding = Geocoding();

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
    '1:00 am',
    '2:00 am',
    '3:00 am',
    '4:00 am',
    '5:00 am',
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
    '11:00 pm',
    '12:00 am'
  ];
  final List<Categoria> _categoria = [];
  List<String> _finalCategories = [];
  List<String> _finalZonas = [];
  final List<Categoria> _tiposRest = [];
  Categoria? _selectedTipoRest;
  List<File> arrayFiles = <File>[];

  List<GeocodingResult>? futureCodigosPostales = <GeocodingResult>[];
  List<GeocodingResult> _lastOptions = <GeocodingResult>[];
  final List<Map<String, dynamic>> mesas = [
    {
      'nombre': 'NOMBRE',
      'accion': 'ACCION',
    }
  ];

  final List<String> zonas = [
    "Barra",
    "Bar",
    "Habitual",
    "Mesa Alta",
    "Sala",
    "Terraza"
  ];

  late CameraController controller;

  void setMap(double lat, double lng) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15));
    //controller.animateCamera(CameraUpdate.scrollBy(50.0, 50.0));
  }

  Future<void> getUserData() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isNotEmpty) {
      if (sesion[0]['lat'] == null || sesion[0]['long'] == null) {
        _setCoords();
      } else {
        banderaMarket = true;
        double lat = double.parse(sesion[0]['lat']);
        double lng = double.parse(sesion[0]['long']);
        _marker = LatLng(lat, lng);
        setMap(lat, lng);
      }
    }
  }

  Future<void> _setCoords() async {
    dynamic geo = await determinePosition();

    Map<String, dynamic> update = {'lat': geo.longitude, 'long': geo.latitude};
    await serviceDB.instance.updateRecord('users', update, 'id_user', 1);

    banderaMarket = true;
    _marker = LatLng(geo.longitude, geo.latitude);
    setMap(geo.longitude, geo.latitude);
  }

  Future<void> getCategories() async {
    final categories = await get('', 'integration',
        'categories/list?searchCriteria[filterGroups][0][filters][1][field]=is_visible_app&searchCriteria[filterGroups][0][filters][1][value]=1&searchCriteria[filterGroups][0][filters][1][conditionType]=eq&searchCriteria[sortOrders][0][field]=name&searchCriteria[sortOrders][0][direction]=ASC');
    if (categories.isNotEmpty) {
      categories['items'].forEach((element) {
        if (element['parent_id'] == 2) {
          _tiposRest.add(Categoria(id: element['id'], name: element['name']));
        }
      });
      setState(() {});
    }
  }

  Future<void> getSubCategories() async {
    if (_selectedTipoRest == null) return;

    final categories = await get('', 'integration',
        'categories/list?searchCriteria[filterGroups][0][filters][1][field]=is_visible_app&searchCriteria[filterGroups][0][filters][1][value]=1&searchCriteria[filterGroups][0][filters][1][conditionType]=eq&searchCriteria[sortOrders][0][field]=name&searchCriteria[sortOrders][0][direction]=ASC&searchCriteria[filterGroups][0][filters][1][field]=parent_id&searchCriteria[filterGroups][0][filters][1][value]=${_selectedTipoRest?.id}&searchCriteria[filterGroups][0][filters][1][conditionType]=eq');
    if (categories.isNotEmpty) {
      categories['items'].forEach((element) {
        _categoria.add(Categoria(id: element['id'], name: element['name']));
      });
      setState(() {});
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future _pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (returnImage == null) return;
    setState(() {
      arrayFiles.add(File(returnImage.path));
      //selectedIMage = File(returnImage.path);
      //_image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop(); //close the model sheet
  }

  Future _pickImageFromCamera() async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (returnImage == null) return;
    setState(() {
      arrayFiles.add(File(returnImage.path));
      //selectedIMage = File(returnImage.path);
      //_image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  Future setCameras() async {
    return await availableCameras();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    //futurePais = _catalogService.fetchPaises();
    futureEstado = _catalogService.fetchEstados("MX");
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Agregar Restaurante',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            onPressed: () => Navigator.pushNamed(context, 'profile'),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
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
                      child: const SizedBox(
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
                      child: const SizedBox(
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
              crearDescripcion(),
              const SizedBox(height: 10.0),
              crearCategorias(),
              const SizedBox(height: 10.0),
              crearUbicacion(),
              const SizedBox(height: 10.0),
              crearReservaciones(),
              const SizedBox(height: 10.0),
              crearHorarios(),
              const SizedBox(height: 10.0),
              crearImagenes(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user =
                        await serviceDB.instance.getById('users', 'id_user', 1);
                    if (user.isEmpty) {
                      //print('error user empty');
                      return;
                    }

                    Map<String, dynamic> arraSlot = {};
                    for (var element in _daysOfWeek) {
                      if (element['checked'] == true) {
                        //print(element);
                        //arraSlot[element['index'].toString()] =
                        arraSlot[element['index'].toString()] = element['hora'];
                      }
                    }

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
                        "attribute_code": "price_charged_per_table",
                        "value": "2"
                      },
                      {
                        "attribute_code": "cancellation_available",
                        "value": "1"
                      },
                      //Tener consideracion con este campo
                      {"attribute_code": "no_of_guests", "value": "100"},
                      {
                        "attribute_code": "max_capacity",
                        "value": _maxCapacity.text
                      },
                      {
                        "attribute_code": "slot_duration",
                        "value": _slotDuration.text
                      },
                      {
                        "attribute_code": "prevent_scheduling_before",
                        "value": _preventSchedulingBefore.text
                      },
                      {
                        "attribute_code": "break_time_bw_slot",
                        "value": _breakTimeBwSlot.text
                      },
                      {"attribute_code": "show_map_loction", "value": "1"},
                      {
                        "attribute_code": "restaurant_number",
                        "value": _numberPhone.text
                      },
                      {
                        "attribute_code": "product_city",
                        "value": _selectedCiudad?.statecity
                      },
                      {
                        'attribute_code': 'hotel_address',
                        'value': _direccionController.text
                      },
                      {"attribute_code": "hotel_country", "value": "MX"},
                      {
                        "attribute_code": "hotel_state",
                        "value": _selectedEstado?.label
                      },
                      {
                        "attribute_code": "location",
                        "value":
                            "${_direccionController.text}, ${_selectedEstado?.label}., México"
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
                        "attribute_code": "tables_by_restaurant",
                        "value": _tablesByRestaurantController.text
                      },
                      {"attribute_code": "created_by", "value": user[0]['id']},
                      {"attribute_code": "updated_by", "value": user[0]['id']},
                    ]);

                    List<Map<String, dynamic>> options = [];
                    Map<String, dynamic> table = {
                      "title": "Zona",
                      "type": "drop_down",
                      "sort_order": 1,
                      "is_require": true,
                      "product_sku": _skuController.text,
                      "values": []
                    };
                    options.add(table);
                    Map<String, dynamic> typeTable = {
                      "title": "Tipo de Mesa",
                      "type": "drop_down",
                      "sort_order": 2,
                      "is_require": true,
                      "product_sku": _skuController.text,
                      "values": []
                    };
                    options.add(typeTable);

                    int indice = 0;
                    int indiceMesa = 0;
                    for (String data in _finalZonas) {
                      if (data == 'Habitual' || data == 'Mesa Alta') {
                        typeTable['values'].add({
                          "title": data,
                          "price": 0,
                          "price_type": "fixed",
                          "sku": data,
                          "sort_order": indiceMesa
                        });
                        indiceMesa++;
                      } else {
                        table['values'].add({
                          "title": data,
                          "price": 0,
                          "price_type": "fixed",
                          "sku": data,
                          "sort_order": indice
                        });
                        indice++;
                      }
                    }

                    /*int indice = 0;
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
                    }*/

                    Map<String, dynamic> producto = {
                      'product': {
                        'name': _nombreController.text,
                        'attribute_set_id': 13,
                        'sku': _skuController.text,
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

                    /*print('*******************options****************');
                    print(options);

                    print('*******************producto****************');
                    print(producto);

                    print('*******************arraSlot****************');
                    print(arraSlot);

                    print(
                        '*******************customAttributes****************');
                    print(customAttributes);*/

                    final restaurante =
                        await post('', 'integration', 'products', producto, '');

                    /*print('rest --->');
                    print(restaurante);*/

                    if (restaurante != null) {
                      responseSuccessWarning(
                          context, 'Restaurante registrado correctamente');

                      int position = 1;
                      //arrayFiles.forEach((element) async
                      for (File element in arrayFiles) {
                        final bytes = File(element.path).readAsBytesSync();
                        String img64 = base64Encode(bytes);

                        var img = {
                          "entry": [
                            {
                              "media_type": "image",
                              "label": "img_${_skuController.text}_$position",
                              "position": position,
                              "disabled": false,
                              "types": ["image", "small_image", "thumbnail"],
                              "content": {
                                "base64_encoded_data": img64,
                                "type": "image/jpeg",
                                "name":
                                    "img_${_skuController.text}_$position.jpg"
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
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2))),
                child: const Text(
                  'Agregar Restaurante',
                  style: TextStyle(color: Colors.white),
                ),
              )
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
                    icon: const Icon(Icons.delete))),
        //Flexible(child: Text("${mesas[index]['pago']}")),
        //Flexible(child: Text("${mesas[index]['total']}"))
      ],
    );
  }

  Container nameInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _nombreController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Nombre del restaurante',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.business_sharp),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          style: const TextStyle(color: Colors.black), // Texto negro
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre del restaurante';
            }
            return null;
          },
        ));
  }

  Container skuInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _skuController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'SKU',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.qr_code_2_sharp),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          style: const TextStyle(color: Colors.black), // Texto negro
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el SKU';
            }
            return null;
          },
        ));
  }

  Padding categoriasSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      child: DropdownButtonFormField<Categoria>(
        // Cambiado a DropdownButtonFormField
        value: _selectedTipoRest,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down), // Icono negro
        elevation: 0, // Sin elevación (sombra)
        style: const TextStyle(color: Colors.black), // Texto negro
        decoration: const InputDecoration(
          // Decoración personalizada
          labelText: 'Selecciona una categoría', // Etiqueta (opcional)
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black, width: 1.0), // Borde negro 2px
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black, width: 1.0), // Borde negro 2px
          ),
          border: OutlineInputBorder(
            // Borde cuando está abierto
            borderSide:
                BorderSide(color: Colors.black, width: 1.0), // Borde negro 2px
          ),
        ),
        onChanged: (Categoria? value) {
          setState(() {
            _selectedTipoRest = value!;
            getSubCategories();
          });
        },
        items: _tiposRest.map<DropdownMenuItem<Categoria>>((Categoria value) {
          return DropdownMenuItem<Categoria>(
            value: value,
            child: Text(value.name,
                style: const TextStyle(color: Colors.black)), // Texto negro
          );
        }).toList(),
      ),
    );
  }

  Padding subCategoriasMultiSelect() {
    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
        child: MultiSelectBottomSheetField(
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
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(4.0), // Opcional
          ),
          title: const Text(
            "Categorias relacionadas",
            style: TextStyle(color: Colors.black),
          ),
          items: _categoria
              .map((cat) => MultiSelectItem<Categoria>(cat, cat.name))
              .toList(),
          onConfirm: (values) {
            _finalCategories = [];
            _finalCategories.add(_selectedTipoRest!.id.toString());
            for (dynamic element in values) {
              _finalCategories.add(element.id.toString());
            }
            setState(() {});
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {},
            chipColor: Colors.white, // Fondo de chip en negro
            textStyle:
                const TextStyle(color: Colors.black), // Texto de chip en blanco
          ),
          selectedItemsTextStyle: const TextStyle(color: Colors.white),
          itemsTextStyle: const TextStyle(color: Colors.black),
        ));
  }

  Padding zonasMultiSelect() {
    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
        child: MultiSelectBottomSheetField(
          initialChildSize: 0.4,
          listType: MultiSelectListType.CHIP,
          searchable: true,
          buttonText: const Text(
            "Zonas",
            style: TextStyle(color: Colors.black),
          ),
          buttonIcon: const Icon(Icons.arrow_drop_down,
              color: Colors.black), // Ícono opcional
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(4.0), // Opcional
          ),
          title: const Text(
            "Zonas",
            style: TextStyle(color: Colors.black),
          ),
          items: zonas.map((cat) => MultiSelectItem<String>(cat, cat)).toList(),
          onConfirm: (values) {
            _finalZonas = [];
            //_finalCategories.add(_selectedTipoRest!.id.toString());
            for (dynamic element in values) {
              _finalZonas.add(element);
            }
            setState(() {});
            //_finalZonas.add(_selectedTipoRest!.id.toString());
            /*for (dynamic element in values) {
              _finalZonas.add(element.id.toString());
            }
            print('_finalZonas');
            print(_finalZonas);
            setState(() {});*/
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {},
            chipColor: Colors.white, // Fondo de chip en negro
            textStyle:
                const TextStyle(color: Colors.black), // Texto de chip en blanco
          ),
          selectedItemsTextStyle: const TextStyle(color: Colors.white),
          itemsTextStyle: const TextStyle(color: Colors.black),
        ));
  }

  Container descriptionInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _descripcionController,
          maxLines: 4,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Descripcion del restaurante',
              style: TextStyle(color: Colors.grey),
            ),
            //suffixIcon: const Icon(Icons.document_scanner),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          style: const TextStyle(color: Colors.black), // Texto negro
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el descripcion del restaurante';
            }
            return null;
          },
        ));
  }

  Container cantTablesInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _tablesByRestaurantController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Mesas por restaurantes',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.table_bar),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          style: const TextStyle(color: Colors.black), // Texto negro
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el cantidad de mesas por restaurante';
            }

            /*if (num.tryParse(value) == null) {
              return '"$value" is not a valid number';
            }*/
            return null;
          },
        ));
  }

  Container direcccionInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Autocomplete<GeocodingResult>(
        fieldViewBuilder:
            ((context, textEditingController, focusNode, onFieldSubmitted) =>
                TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (value) => onFieldSubmitted,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(gapPadding: 1),
                    hintText: "Direccion",
                  ),
                )),
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<GeocodingResult>.empty();
          }

          futureCodigosPostales = await _geocoding
              .getGeocoding(textEditingValue.text, []).then((data) {
            if (data?.status != 'OK') {
              return [];
            }
            return data?.results;
          });

          if (futureCodigosPostales == null) {
            return _lastOptions;
          }
          List<GeocodingResult> options = <GeocodingResult>[];
          options = futureCodigosPostales!;
          _lastOptions = options;
          return options;
        },
        onSelected: (GeocodingResult selection) async {
          if (selection.geometry != null &&
              selection.geometry!.location != null) {
            banderaMarket = true;
            double lat =
                double.parse(selection.geometry!.location!.lat.toString());
            double lng =
                double.parse(selection.geometry!.location!.lng.toString());
            setMap(lat, lng);
            _marker = LatLng(lat, lng);
            setState(() {});
          }

          debugPrint('You just selected ${selection.formattedAddress}');
        },
      ),
    );
  }

  Padding paisesSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
      child: FutureBuilder<List<Pais>>(
        future: futurePais,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButtonFormField<Pais>(
              value: _selectedPais,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 30,
              elevation: 0,
              style: const TextStyle(color: Colors.black),
              /*decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.zero, // Sin redondeles
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.zero, // Sin redondeles
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.zero, // Sin redondeles
                ),
              ),*/
              onChanged: (Pais? newValue) {
                setState(() {
                  _selectedPais = newValue as Pais;
                  futureEstado =
                      _catalogService.fetchEstados("${_selectedPais?.code}");
                });
              },
              items: snapshot.data?.map<DropdownMenuItem<Pais>>((Pais value) {
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
    );
  }

  Padding estadoSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      child: FutureBuilder<List<Estado>>(
        future: futureEstado,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButtonFormField<Estado>(
              isExpanded: true,
              // Cambiado a DropdownButtonFormField
              value: _selectedEstado,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 30,
              elevation: 0, // Eliminar elevación (sombra)
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                // Decoración personalizada
                labelText: 'Selecciona un estado', // Etiqueta (opcional)
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 1.0), // Borde negro 2px
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 1.0), // Borde negro 2px
                ),
                border: OutlineInputBorder(
                  // Borde cuando está abierto
                  borderSide: BorderSide(
                      color: Colors.black, width: 1.0), // Borde negro 2px
                ),
              ),
              onChanged: (Estado? newValue) {
                setState(() {
                  _selectedEstado = newValue as Estado;
                  _selectedCiudad = null;
                  futureCiudad =
                      _catalogService.fetchCiudades("${_selectedEstado?.code}");
                });
              },
              items:
                  snapshot.data?.map<DropdownMenuItem<Estado>>((Estado value) {
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
    );
  }

  Padding ciudadSelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      child: FutureBuilder<List<Ciudad>>(
        future: futureCiudad,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButtonFormField<Ciudad>(
              isExpanded: true,
              value: _selectedCiudad,
              icon: const Padding(
                padding: EdgeInsets.only(
                    left: -0.0), // Mueve el icono 10px a la izquierda
                child: Icon(Icons.arrow_drop_down, color: Colors.black),
              ),
              iconSize: 30,
              elevation: 0,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                // Decoración personalizada
                labelText: 'Selecciona una ciudad', // Etiqueta (opcional)
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 1.0), // Borde negro 2px
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 1.0), // Borde negro 2px
                ),
                border: OutlineInputBorder(
                  // Borde cuando está abierto
                  borderSide: BorderSide(
                      color: Colors.black, width: 1.0), // Borde negro 2px
                ),
              ),
              onChanged: (Ciudad? newValue) {
                setState(() {
                  _selectedCiudad = newValue as Ciudad;
                });
              },
              items:
                  snapshot.data?.map<DropdownMenuItem<Ciudad>>((Ciudad value) {
                return DropdownMenuItem<Ciudad>(
                  value: value,
                  child: Text(value.statecity,
                      style:
                          const TextStyle(color: Colors.black)), // Texto negro
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
    );
  }

  Container telefonoInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _numberPhone,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(
            // Esto es opcional, pero recomendado
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: Colors.black, // Borde predeterminado en negro
            ),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          label: const Text(
            'Telefono',
            style: TextStyle(color: Colors.grey),
          ),
          suffixIcon: const Icon(Icons.phone),
          ///////
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0), // Borde negro cuando está habilitado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0), // Borde negro más grueso cuando está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese el Teléfono de contacto';
          }
          return null;
        },
      ),
    );
  }

  Container duaracionInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: _slotDuration,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Duración de la reservacion',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.business_sharp),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese Tiempo';
            }
            return null;
          }),
    );
  }

  Container breakInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _breakTimeBwSlot,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Tiempo entre reservaciones',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.timer_sharp),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese Tiempo';
            }
            return null;
          },
        ));
  }

  Container antesDeInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _preventSchedulingBefore,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Evitar programación antes de',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.timer_sharp),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese Tiempo';
            }
            return null;
          },
        ));
  }

  SizedBox showImages() {
    return arrayFiles.isNotEmpty
        ? SizedBox(
            height: 300,
            width: 250,
            child: ListView.builder(
              itemCount: arrayFiles.length,
              itemBuilder: (context, index) {
                if (arrayFiles.isEmpty) {
                  return const Center(
                    child: Text("Sin imagenes para mostrar"),
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
          )
        : const SizedBox(
            child: Center(
              child: Text("Sin imagenes para mostrar"),
            ),
          );
  }

  Card crearDescripcion() {
    return Card.outlined(
        clipBehavior: Clip.hardEdge,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'DESCRIPCIÓN',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15.0),
              nameInput(),
              const SizedBox(height: 12.0),
              skuInput(),
              const SizedBox(height: 12.0),
              descriptionInput(),
              const SizedBox(height: 12.0),
            ]));
  }

  Card crearCategorias() {
    return Card.outlined(
        clipBehavior: Clip.hardEdge,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'CATEGORÍAS Y ZONAS',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15.0),
              categoriasSelect(),
              const SizedBox(height: 10.0),
              subCategoriasMultiSelect(),
              const SizedBox(height: 10.0),
              cantTablesInput(),
              const SizedBox(height: 10.0),
              zonasMultiSelect(),
              const SizedBox(height: 10.0),
            ]));
  }

  Card crearUbicacion() {
    return Card.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'UBICACIÓN',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12.0),
          direcccionInput(),
          const SizedBox(height: 12.0),
          SizedBox(
            height: 200,
            width: 90,
            child: GoogleMap(
                myLocationEnabled: true,
                onCameraMove: ((positiones) {
                  setState(() {
                    _marker = LatLng(positiones.target.latitude,
                        positiones.target.longitude);
                  });
                }),
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialPosition,
                onTap: (LatLng latLng) {
                  //print('${latLng.latitude}, ${latLng.longitude}');
                  _marker = LatLng(latLng.latitude, latLng.longitude);
                  setState(() {});
                },
                markers: {
                  Marker(
                    //draggable: true,
                    markerId: const MarkerId('Y'),
                    position: _marker,
                    /*onDragEnd: ((newPosition) {
                        print(newPosition.latitude);
                        print(newPosition.longitude);
                      })*/
                  )
                }),
          ),
          /*const SizedBox(height: 10.0),
          paisesSelect(),*/
          const SizedBox(height: 12.0),
          estadoSelect(),
          const SizedBox(height: 12.0),
          ciudadSelect(),
          const SizedBox(height: 12.0),
          telefonoInput(),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Card crearReservaciones() {
    return Card.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'INTERVALOS DE RESERVACIÓN',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12.0),
          duaracionInput(),
          const SizedBox(height: 12.0),
          breakInput(),
          const SizedBox(height: 10.0),
          antesDeInput(),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Card crearHorarios() {
    return Card.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'HORARIOS DE ANTENCIÓN',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10.0),
          SingleChildScrollView(
              child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _daysOfWeek.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
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
                            child: Center(
                              widthFactor: 1,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: SizedBox(
                                      width: 150, // Ajusta el ancho deseado
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        //value: _daysOfWeek[index]['hora'][0]['from'],
                                        items: _timeOptions.map((String time) {
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
                                                width: 1.0), // Borde negro
                                            borderRadius: BorderRadius
                                                .zero, // Sin redondeles
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0), // Borde negro
                                            borderRadius: BorderRadius
                                                .zero, // Sin redondeles
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0), // Borde negro
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: SizedBox(
                                      // Limitamos el ancho del DropdownButtonFormField
                                      width:
                                          150, // Ajusta este valor según tus necesidades
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        //value: _restaurant.horaInicio,
                                        items: _timeOptions.map((String time) {
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
                                                width: 1.0), // Borde negro
                                            borderRadius: BorderRadius
                                                .zero, // Sin redondeles
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0), // Borde negro
                                            borderRadius: BorderRadius
                                                .zero, // Sin redondeles
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0), // Borde negro
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
                                ],
                              ),
                            ),
                          ),
                        ]);
                      }))),
        ],
      ),
    );
  }

  Card crearImagenes() {
    return Card.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'IMAGENES',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero)),
            onPressed: () async {
              showImagePickerOption(context);
            },
            icon: const Icon(Icons.camera),
            label: const Text('Seleccionar Foto'),
          ),
          showImages(),
        ],
      ),
    );
  }
}
