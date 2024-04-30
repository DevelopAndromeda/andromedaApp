import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:andromeda/screens/restaurant/review.dart';

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
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _personasController = TextEditingController();
  final _notasController = TextEditingController();

  final List<String> imagenes = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
    'assets/image4.jpg',
    'assets/image5.jpg',
  ];

  //final String nombre = "Nombre del Restaurante";
  final String direccion = "Dirección del Restaurante";
  final String tipoComida = "Tipo de Comida";
  final String horarios = "Horarios de Servicio";
  //final String descripcion =
  //"Descripción del restaurante. Aquí puedes agregar una descripción detallada de lo que ofrece el restaurante.";

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _selectTime(BuildContext context) async {
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
  }

  @override
  void initState() {
    print(widget.data);
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    direccion,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tipo de Comida: $tipoComida',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Horarios de Servicio: $horarios',
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
                  /*DataTable(columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Reservacion',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Reseñas',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Detalle',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ], rows: const <DataRow>[]),*/
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
                    height: 350,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Column(
                          children: [
                            SizedBox(height: 10),
                            ListTile(
                              title: Text(
                                  "Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                              trailing: Icon(Icons.calendar_today),
                              onTap: () => _selectDate(context),
                            ),
                            ListTile(
                              title: Text(
                                  "Hora: ${_selectedTime.format(context)}"),
                              trailing: Icon(Icons.access_time),
                              onTap: () => _selectTime(context),
                            ),
                            TextField(
                              controller: _personasController,
                              decoration: InputDecoration(
                                  labelText: 'Número de personas'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller: _notasController,
                              decoration: InputDecoration(
                                  labelText: 'Notas adicionales (opcional)'),
                              keyboardType: TextInputType.text,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final sesion = await serviceDB.instance
                                      .getById('users', 'id_user', 1);
                                  // Generar carrito vacio
                                  if (sesion.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Nesecitas iniciar una sesion')));
                                    return;
                                  }

                                  var myCart = await get(sesion[0]['token'],
                                      'custom', 'carts/mine');
                                  print(myCart);
                                  if (myCart == null) {
                                    print('llamar con post');
                                    myCart = await post(sesion[0]['token'],
                                        'custom', 'carts/mine', {}, '');
                                  }

                                  print('Llamar los items del carrito');
                                  final items = await get(sesion[0]['token'],
                                      'custom', 'carts/mine/items');

                                  print('items');
                                  print(items);

                                  if (items.length > 0) {
                                    print('existen items');
                                  } else {
                                    print('llamar atributos');
                                    //Llamar labels del producot
                                    final labels = await get('', 'integration',
                                        'products/${widget.data['sku']}/options');
                                    print('labels');
                                    print(labels);

                                    //Agregar Items
                                    Map<String, Map<String, dynamic>> item = {
                                      "cartItem": {
                                        "quote_id": myCart['id'],
                                        "sku": widget.data['sku'],
                                        "qty": 2,
                                        "product_type": "booking",
                                        "product_option": {
                                          "extension_attributes": {
                                            "custom_options": [
                                              {
                                                "option_id": "390",
                                                "option_value": "2024-06-26"
                                              },
                                              {
                                                "option_id": "391",
                                                "option_value": "11:20 am"
                                              },
                                              {
                                                "option_id": "3",
                                                "option_value": "something"
                                              },
                                              {
                                                "option_id": "4",
                                                "option_value":
                                                    "Table (2 Guests)"
                                              },
                                              {
                                                "option_id": "389",
                                                "option_value": 1
                                              }
                                            ],
                                            "configurable_item_options": [
                                              {
                                                "option_id": "product",
                                                "option_value": 3
                                              },
                                              {
                                                "option_id":
                                                    "selected_configurable_option",
                                                "option_value": "0"
                                              },
                                              {
                                                "option_id": "related_product",
                                                "option_value": "0"
                                              },
                                              {
                                                "option_id": "slot_id",
                                                "option_value": 0
                                              },
                                              {
                                                "option_id": "slot_day_index",
                                                "option_value": 4
                                              },
                                              {
                                                "option_id":
                                                    "charged_per_count",
                                                "option_value": 2
                                              },
                                              {
                                                "option_id": "item",
                                                "option_value": 3
                                              }
                                            ]
                                          }
                                        },
                                        "extension_attributes": {}
                                      }
                                    };

                                    print(item);
                                  }

                                  // Aquí puedes agregar la lógica para procesar la reserva
                                  /*showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Reserva Realizada'),
                                      content: Text(
                                          'Tu reserva ha sido realizada con éxito.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );*/
                                },
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
                        /*Timer(const Duration(seconds: 5), () {
                          Navigator.of(context).push(_createRoute());
                        }),*/
                        Center(),
                        Center(),
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
