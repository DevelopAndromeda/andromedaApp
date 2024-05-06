import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:andromeda/screens/restaurant/review.dart';
import 'package:intl/intl.dart';

class MyDetailPage extends StatefulWidget {
  //final int data;
  final Map<String, dynamic> data;
  const MyDetailPage({super.key, required this.data});

  @override
  State<MyDetailPage> createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  String Hora = '';
  int slot_id = 0;
  int personas = 0;
  //TimeOfDay _selectedTime = TimeOfDay.now();
  //final _personasController = TextEditingController();
  //final _notasController = TextEditingController();
  //late List<dynamic> _options = [];
  final List<String> imagenes = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
    'assets/image4.jpg',
    'assets/image5.jpg',
  ];
  //late Future<Map<String, dynamic>> _daySlot;
  final List<String> _diasSemana = [
    '',
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];
  List _options = [];
  Map _slot = {};
  List<dynamic> _slotDay = [];
  List<dynamic> _allSlotDay = [];
  //List<Map<String, dynamic>> _timeSlot = [];
  Future<void> getSlot(String? id) async {
    print('getSlot -> $id');
    _slot = await get('', '', 'restaurant/product/${id}');
    _slot = _slot['data']['info'];
    print(_slot);
  }

  Future<void> getOptions(String? sku) async {
    print('getOptions -> $sku');
    _options = await get('', 'integration', 'products/$sku/options');
    print(_options);
  }

  //final String nombre = "Nombre del Restaurante";
  //final String direccion = "Dirección del Restaurante";
  //final String tipoComida = "Tipo de Comida";
  //final String horarios = "Horarios de Servicio";
  //final String descripcion =
  //"Descripción del restaurante. Aquí puedes agregar una descripción detallada de lo que ofrece el restaurante.";

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    _slot.forEach((key, value) {
      if (int.parse(key) == picked?.weekday) {
        _slotDay = value;
        return;
      }
    });
    print(_slotDay);
    _allSlotDay = [];
    _slotDay.forEach((e) {
      if (e['slots_info'].runtimeType == List) {
        _allSlotDay.addAll(e['slots_info']);
      } else {
        _allSlotDay.addAll(e['slots_info'].values);
      }
    });
    print('_allSlotDay');
    print(_allSlotDay);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /*_selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    print(_selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }*/

  Future<void> generateOrden() async {
    final sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    // Generar carrito vacio
    if (sesion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nesecitas iniciar una sesion')));
      return;
    }

    print('llamar con post');
    //Creamos Carrito y lo guardamos
    var myCart = await post(sesion[0]['token'], 'custom', 'carts/mine', {}, '')
        .then((value) async {
      return await get(sesion[0]['token'], 'custom', 'carts/mine');
    });
    print(myCart);

    List<Map<String, dynamic>> custom_options = [];
    if (_options.isEmpty) {
      await getOptions(widget.data['sku']);
    }
    print(_options);
    for (dynamic item in _options) {
      print('item $item');
      String value = '';
      if (item['title'] == 'Booking Date') {
        value = DateFormat('yyyy-MM-dd').format(_selectedDate).toString();
      }

      if (item['title'] == 'Booking Slot') {
        value = Hora;
      }

      if (item['title'] == 'Special Request/Notes') {
        value = "something";
      }

      if (item['title'] == 'Charged Per') {
        value = "Table (2 Guests)";
      }

      if (item['title'] == 'ejemplo de mesa') {
        value = "1";
      }

      custom_options
          .add({"option_id": item['option_id'], "option_value": value});
    }
    print('***custom_options***');
    print(custom_options);

    List<Map<String, dynamic>> configurable_item_options = [];
    configurable_item_options.addAll([
      {"option_id": "product", "option_value": widget.data['id']},
      {"option_id": "item", "option_value": widget.data['id']},
      {"option_id": "selected_configurable_option", "option_value": "0"},
      {"option_id": "related_product", "option_value": "0"},
      //{"option_id": "parent_slot_id", "option_value": 0},
      {"option_id": "slot_id", "option_value": slot_id},
      {"option_id": "slot_day_index", "option_value": _selectedDate.weekday},
      {"option_id": "charged_per_count", "option_value": 2},
    ]);
    print('***configurable_item_options***');
    print(configurable_item_options);

    Map<String, dynamic> _cartItem = {
      "cartItem": {
        "quote_id": myCart['id'],
        "sku": widget.data['sku'],
        "qty": 1,
        "product_type": "booking",
        "product_option": {
          "extension_attributes": {
            "custom_options": custom_options,
            "configurable_item_options": configurable_item_options
          }
        }
      },
      "booking_date": DateFormat('dd/MM/yyy').format(_selectedDate).toString(),
      "booking_time": Hora
    };

    print('_cartItem');
    print(_cartItem);

    //Revisar productos
    final items = await get(sesion[0]['token'], 'custom', 'carts/mine/items');
    print('***items***');
    print(items);

    if (items.isEmpty) {
      //Agregar item al carrito
      final addItem = await post(
          sesion[0]['token'], 'custom', 'carts/mine/items', _cartItem, 'v2');
      print("***addItem***");
      print(addItem);
    } else {
      bool bandera = true;
      for (dynamic data in items) {
        if (data['sku'] == widget.data['sku']) {
          bandera = false;
        }
      }

      if (bandera) {
        //Agregar item al carrito
        final addItem = await post(
            sesion[0]['token'], 'custom', 'carts/mine/items', _cartItem, 'v2');
        print("***addItem***");
        print(addItem);
      }
    }

    //Agregamos Bulling y
    Map<String, dynamic> _info = {
      "addressInformation": {
        "billing_address": {
          "firstname": "le aza",
          "lastname": "CabSua",
          "street": ["elm street"],
          "country_id": "MX",
          "region": "QUE",
          "region_code": "QUE",
          "region_id": "956",
          "city": "Queretaro",
          "telephone": 8855224466,
          "postcode": "76243",
          "email": "emailfake@email.com"
        },
        "shipping_address": {
          "firstname": "le aza",
          "lastname": "CabSua",
          "street": ["elm street"],
          "country_id": "MX",
          "region": "QUE",
          "region_code": "QUE",
          "region_id": "956",
          "city": "Queretaro",
          "telephone": 8855224466,
          "postcode": "76243",
          "email": "emailfake@email.com"
        },
        "shipping_method_code": "",
        "shipping_carrier_code": ""
      }
    };

    //Set info
    final shippingInfo = await post(sesion[0]['token'], 'custom',
        'carts/mine/shipping-information', _info, '');
    print('shippingInfo');
    print(shippingInfo);

    //Generate Order
    final orden = await put(
        sesion[0]['token'],
        'custom',
        'carts/mine/order',
        {
          "paymentMethod": {"method": "checkmo"}
        },
        '');
    print('orden');
    print(orden);

    //
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reserva Realizada'),
        content: Text('Tu reserva ha sido realizada con éxito.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    print(widget.data);
    super.initState();
    //_daySlot = getSlot(widget.data['id']);
    _tabController = TabController(length: 3, vsync: this);
    getOptions(widget.data['sku']);
    getSlot(widget.data['id'].toString());
    //_options = getOptions(widget.data['sku']);

    //print('options $_options');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Información y Reserva del Restaurante'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                enableInfiniteScroll: true,
                viewportFraction: 0.8,
              ),
              items: imagenes.map((imagen) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Image.asset(
                        imagen,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Direccion',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tipo de Comida: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Horarios de Servicio: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Descripción:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    getCustomAttribute(
                        widget.data['custom_attributes'], 'short_description'),
                    style: TextStyle(fontSize: 16),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Color.fromARGB(255, 0, 0, 0),
                    indicatorColor: Colors.black,
                    onTap: (index) {
                      print(index);
                      if (index == 1) {
                        setState(() {
                          index = 0;
                        });
                        Navigator.of(context).push(_createRoute());
                      }
                    },
                    tabs: const <Widget>[
                      Tab(
                        text: 'Reservacion',
                      ),
                      Tab(
                        text: 'Reseñas',
                      ),
                      Tab(
                        text: 'Detalles',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Column(
                          children: [
                            SizedBox(height: 20.0),
                            Text(
                              'Día y Hora de Reserva',
                              style: TextStyle(fontSize: 25),
                            ),
                            SizedBox(height: 10.0),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: ListTile(
                                  title: Text(
                                      "Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                                  trailing: Icon(Icons.calendar_today),
                                  onTap: () => _selectDate(context),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 3),
                                height: size.height * 1.5,
                                width: double.infinity,
                                child: GridView.builder(
                                    itemCount: _allSlotDay.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1.5,
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 4.0,
                                            mainAxisSpacing: 4.0),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 232, 239, 243),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(0, 17),
                                                blurRadius: 17,
                                                spreadRadius: -23,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              print(index);
                                              print(_allSlotDay[index]);
                                              Hora = _allSlotDay[index]['time'];
                                              slot_id = index;
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.timer_sharp,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "${_allSlotDay[index]['time']}",
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                      /*return Text(
                                        "${_allSlotDay[index]['qty']} - ${_allSlotDay[index]['time']}",
                                      );*/
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Flexible(
                              child: Container(
                                child: DropdownButtonFormField<String>(
                                  items: [],
                                  decoration:
                                      InputDecoration(labelText: 'Personas'),
                                  onChanged: (String? newValue) {},
                                ),
                              ),
                            ),
                            /*Row(children: <Widget>[
                              Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: SingleChildScrollView(
                                        child: SizedBox(
                                      width: double.infinity,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _slotDay.length,
                                          itemBuilder: (cotext, index) {
                                            return Column(
                                              children: [
                                                Text(
                                                    "${_slotDay[index]['from']} - ${_slotDay[index]['to']}"),
                                                DropdownButtonFormField<String>(
                                                    items: _tiemposSlot(
                                                        _slotDay[index]
                                                            ['slots_info']),
                                                    decoration: InputDecoration(
                                                        labelText: 'Hora'),
                                                    onChanged:
                                                        (String? newValue) {
                                                      print(
                                                          'value select $newValue');
                                                      //setState(() {
                                                      Hora = newValue!;
                                                      //});
                                                    }),
                                              ],
                                            );
                                          }),
                                    ))),
                              ),
                            ]),*/
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: generateOrden,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    minimumSize: Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    )),
                                child: Text(
                                  'Generar Reserva',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomBar(
        index: 2,
      ),
    );
  }

  List<DropdownMenuItem<String>> _tiemposSlot(data) {
    //print(data.runtimeType);
    List<DropdownMenuItem<String>> lista = [];
    if (data.runtimeType == List) {
      //print('is list');
      //print(data);
      data.forEach((element) => {
            lista.add(DropdownMenuItem<String>(
              value: element['time'],
              child: Text(element['time']),
            ))
          });
    } else {
      //print('no list');
      //print(data);
      //print(data.length);
      data.forEach((ele, value) {
        print(ele);
        print(value);
        lista.add(DropdownMenuItem<String>(
          value: value['time'],
          child: Text(value['time']),
        ));
      });
    }
    return lista;
  }

  Widget createDia(data, Function? _onChanged) {
    print(data);
    List<DropdownMenuItem<String>> menuItems = [];
    data.forEach((i, value) {
      print('index=$i, value=$value');
      menuItems.add(DropdownMenuItem(
          value: i.toString(), child: Text(_diasSemana[int.parse(i)])));
    });
    return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          filled: true,
          hintText: 'Seleccione',
          labelText: 'Dia',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Seleccione...';
          }
          return null;
        },
        onChanged: (String? newValue) {
          _onChanged!(newValue);
        },
        items: menuItems);
  }

  Widget createSelect(dropdownItems, Function? _onChanged, String? titulo) {
    return DropdownButtonFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          filled: true,
          hintText: 'Seleccione $titulo',
          labelText: titulo,
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese Tipo';
          }
          return null;
        },
        onChanged: (String? newValue) {
          _onChanged!(newValue);
        },
        items: dropdownItems);
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MyReviewPage(data: widget.data),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
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
