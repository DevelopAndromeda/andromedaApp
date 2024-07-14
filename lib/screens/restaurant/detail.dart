import 'dart:async';
import 'package:andromeda/blocs/reviews/reviews_bloc.dart';
import 'package:andromeda/services/store.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html_parsed_read_more/html_parsed_read_more.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/inicio/user/user_bloc.dart';

import 'package:andromeda/witgets/make_a_reservation.dart';
import 'package:andromeda/witgets/Button_Base.dart';
import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/utilities/constanst.dart';
import 'package:readmore/readmore.dart';

class MyDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const MyDetailPage({super.key, required this.data});

  @override
  State<MyDetailPage> createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage>
    with TickerProviderStateMixin {
  LatLng _marker = const LatLng(23.3231416, -103.8384764);
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(23.3231416, -103.8384764));
  final Completer<GoogleMapController> _controller = Completer();
  final UserBloc _userBloc = UserBloc();
  final ReviewsBloc _reviewBloc = ReviewsBloc();

  DateTime _selectedDate = DateTime.now();
  String Hora = '';
  int slot_id = 0;
  int personas = 0;
  List<String> imagenes = [];
  List _options = [];
  List<dynamic> _slot = [];
  List<dynamic> _slotDay = [];
  List<dynamic> _allSlotDay = [];
  List<String> personasList = ["1", "2", "3", "4", "5"];

  init() async {
    setImgs();
    getSlot();
    await getOptions();
  }

  setImgs() {
    if (widget.data['media_gallery_entries'] != null) {
      widget.data['media_gallery_entries'].forEach((element) {
        imagenes.add(element['file']);
      });
    } else {
      imagenes.add('assets/notFoundImg.png');
    }
  }

  getSlot() {
    if (widget.data['extension_attributes'] == null) {
      for (dynamic attr in widget.data['custom_attributes']) {
        if (attr['attribute_code'].runtimeType == int) {
          _slot.add(attr);
        }
      }
    } else {
      _slot = widget.data['extension_attributes']['slot_schedules'];
    }
  }

  Future<void> getOptions() async {
    _options =
        await get('', 'integration', 'products/${widget.data['sku']}/options');
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                  onPrimary:
                      Color.fromARGB(255, 255, 255, 255), // selected text color
                  onSurface:
                      Color.fromARGB(255, 255, 255, 255), // default text color
                  primary: Color.fromARGB(99, 255, 255, 255) // circle color
                  ),
              dialogBackgroundColor: Colors.black54,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      fontFamily: 'Quicksand'),
                  backgroundColor: Colors.black54, // Background color
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            child: child!,
          );
        });

    if (widget.data['extension_attributes'] == null) {
      print(widget.data['custom_attributes']);
      for (dynamic attr in widget.data['custom_attributes']) {
        if (attr['attribute_code'].runtimeType == int) {
          //_slot.add(attr);
          if (attr['attribute_code'] == picked?.weekday) {
            _slotDay = attr['value'];
          }
        }
      }
    } else {
      print(widget.data['extension_attributes']);
      for (dynamic attr in widget.data['extension_attributes']
          ['slot_schedules']) {
        if (attr['attribute_code'] == picked?.weekday) {
          _slotDay = attr['value'];
        }
      }
      //_slot = widget.data['extension_attributes']['slot_schedules'];
    }

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
    /*print('_slot');
    print(_slot);
    for (var item in _slot) {
      if (item['attribute_code'] == picked?.weekday) {
        _slotDay = item['value'];
      }
    }
    print('_slotDay');
    print(_slotDay);*/
    /*_allSlotDay = [];
    for (var e in _slotDay) {
      if (e['slots_info'].runtimeType == List) {
        _allSlotDay.addAll(e['slots_info']);
      } else {
        _allSlotDay.addAll(e['slots_info'].values);
      }
    }*/
    //print('_allSlotDay');
    //print(_allSlotDay);
    /*if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }*/
  }

  Future<void> generateOrden(DateTime _selectedDate, int personas) async {
    //print('************* Obtener Sesion *************');
    final sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    // Generar carrito vacio
    if (sesion.isEmpty) {
      responseErrorWarning(context, "Nesecitas iniciar una sesion");
      return;
    }
    //print('************* Sesion: ${sesion} *************');

    //print('************* Generar custom_options: *************');
    List<Map<String, dynamic>> custom_options = [];
    if (_options.isEmpty) {
      await getOptions();
    }
    //print('************* options: ${_options} *************');
    if (_options.isEmpty) {
      responseErrorWarning(context, "No Existen Labels para este producto");
      return;
    }

    for (dynamic item in _options) {
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
        value = "Table (4 Guests)";
      }

      if (item['title'] == 'Zona') {
        value = "13";
      }

      custom_options
          .add({"option_id": item['option_id'], "option_value": value});
    }
    //print('************* custom_options: ${custom_options} *************');

    //print('************* Crear Carrito *************');
    //Creamos Carrito y lo guardamos
    var myCart = await post(sesion[0]['token'], 'custom', 'carts/mine', {}, '')
        .then((value) async {
      return await get(sesion[0]['token'], 'custom', 'carts/mine');
    });
    //print('************* Carrito: ${myCart} *************');

    List<Map<String, dynamic>> configurable_item_options = [];
    configurable_item_options.addAll([
      {"option_id": "product", "option_value": widget.data['id']},
      {"option_id": "item", "option_value": widget.data['id']},
      {"option_id": "selected_configurable_option", "option_value": "0"},
      {"option_id": "related_product", "option_value": "0"},
      {"option_id": "parent_slot_id", "option_value": 0},
      {"option_id": "slot_id", "option_value": slot_id},
      {"option_id": "slot_day_index", "option_value": _selectedDate.weekday},
      {"option_id": "charged_per_count", "option_value": 4},
    ]);
    //print(
    //    '************* configurable_item_options: ${configurable_item_options} *************');

    /*if (myCart != null) {
      myCart['items'].map((element) async {
        await delete(sesion[0]['token'], 'customer',
            'carts/mine/items/${element['item_id']}');
      });
    }*/

    Map<String, dynamic> cartItem = {
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
      "booking_date": DateFormat('MM/dd/yyy').format(_selectedDate).toString(),
      "booking_time": Hora
    };

    //print('************* cartItem: ${_cartItem} *************');

    //Revisar productos
    //print('************* Obtener Items en Carrito *************');
    final items = await get(sesion[0]['token'], 'custom', 'carts/mine/items');
    print('************* items: ${items} *************');

    if (items.isEmpty) {
      //Agregar item al carrito
      print('enviar post');
      print(cartItem);
      final cart = await post(
          sesion[0]['token'], 'custom', 'carts/mine/items', cartItem, 'v2');
      print('response post');
      print(cart);
      //print('************* Agregar Item: ${addItem} *************');
    } else {
      if (items.runtimeType != List) {
        responseErrorWarning(context, 'Vuelve a iniciar sesion');
        return;
      }
      //bool bandera = true;
      for (dynamic data in items) {
        //print('************* SKU: ${data['sku']} *************');
        //print('************* SKU-Actual: ${widget.data['sku']} *************');
        //if (data['sku'] == widget.data['sku']) {
        //  bandera = false;
        //}
        await delete(sesion[0]['token'], 'customer',
            'carts/mine/items/${data['item_id']}');
      }

      //if (bandera) {
      //Agregar item al carrito
      await post(
          sesion[0]['token'], 'custom', 'carts/mine/items', cartItem, 'v2');
      //print('************* Agregar Item: ${addItem} *************');
      //}
    }

    //Agregamos Bulling y
    Map<String, dynamic> info = {
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
    await post(sesion[0]['token'], 'custom', 'carts/mine/shipping-information',
        info, '');
    //print('************* shippingInfo: ${shippingInfo} *************');

    //Generate Order
    final orden = await put(
        sesion[0]['token'],
        'custom',
        'carts/mine/order',
        {
          "paymentMethod": {"method": "checkmo"}
        },
        '');
    //print('************* ORDEN: ${orden} *************');
    //print('************* ORDEN-TYPE: ${orden.runtimeType} *************');
    if (orden.runtimeType != int) {
      responseErrorWarning(context, orden['message']);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reserva Realizada'),
          content: const Text('Tu reserva ha sido realizada con éxito.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              // ignore: prefer_const_constructors
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  _getCoords(String cadena) {
    return cadena.split(',');
  }

  Future<void> getUserData() async {
    final splitter = _getCoords(
        getCustomAttribute(widget.data['custom_attributes'], 'location'));
    if (splitter.length == 2) {
      GoogleMapController controller = await _controller.future;
      _marker = LatLng(double.parse(splitter[0]), double.parse(splitter[1]));
      controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(double.parse(splitter[0]), double.parse(splitter[1])), 5));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    _userBloc.add(GetUser());
    _reviewBloc.add(GetReviewsList(widget.data['sku']));
    init();
    super.initState();
    //getOptions(widget.data['sku']);
    //getSlot(widget.data['id'].toString());
    //setImgs();
    //getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del restaurante',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        leading: BackButton(
          onPressed: () => Navigator.pushNamed(context, 'home'),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            crearSlider(),
            crearInfo(), /*createInfo()*/
          ],
        ),
      ),
    );
  }

  CarouselSlider crearSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: imagen != "assets/notFoundImg.png"
                  ? Image.network(
                      pathMedia(imagen),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      imagen,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            );
          },
        );
      }).toList(),
    );
  }

  Padding crearInfo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dividerLine,
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 32),
            child: Text(
              widget.data['name'],
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          _dividerLine,
          Row(
            children: [
              RatingBarIndicator(
                rating: double.parse(getCustomAttribute(
                        widget.data['custom_attributes'], 'product_score')
                    .toString()),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Color.fromARGB(200, 149, 4, 4),
                ),
                itemCount: 5,
                itemSize: 26.0,
                direction: Axis.horizontal,
              ),
              Text(
                "${getCustomAttribute(widget.data['custom_attributes'], 'product_score')}",
                style: const TextStyle(
                    color: Color(0xff323232),
                    fontSize: 16,
                    fontFamily: 'Exo Bold'),
              ),
              const SizedBox(
                width: 40,
              ),
              const Icon(Icons.comment_bank_outlined),
              const Text(
                "111 reseñas",
                style: TextStyle(
                    color: Color(0xff323232),
                    fontSize: 16,
                    fontFamily: 'Exo Bold'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(Icons.money_outlined),
              const Flexible(
                child: Text(
                  "De MXN300 a MXN400",
                  style: TextStyle(
                      color: Color(0xff323232),
                      fontSize: 16,
                      fontFamily: 'Exo Bold'),
                ),
              ),
              const Icon(Icons.restaurant),
              Flexible(
                child: Text(
                  getCustomAttribute(
                      widget.data['custom_attributes'], 'category_string'),
                  style: const TextStyle(
                      color: Color(0xff323232),
                      fontSize: 16,
                      fontFamily: 'Exo Bold'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: HtmlParsedReadMore(
              readLessText: 'Ver menos',
              readMoreText: 'Más información',
              maxLinesReadLess: 3,
              maxLinesReadMore: 1000,
              textOverflow: TextOverflow.ellipsis,
              fontFamily: 'poppins',
              textButtonFontSize: 14.0,
              buttonAlignment: Alignment.bottomLeft,
              buttonPadding: const EdgeInsets.only(top: 0),
              text: getCustomAttribute(
                  widget.data['custom_attributes'], 'short_description'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Icon(Icons.maps_ugc_rounded),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Ubicacion',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                const SizedBox(
                  width: 44,
                ),
                Flexible(
                  child: Text(
                    "${getCustomAttribute(widget.data['custom_attributes'], 'hotel_address')}, ${getCustomAttribute(widget.data['custom_attributes'], 'location')}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*Center(
            child: SizedBox(
              height: 280,
              width: 380,
              child: GoogleMap(
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialPosition,
                  markers: {
                    Marker(markerId: const MarkerId("Yo"), position: _marker)
                  }),
            ),
          ),*/
          const SizedBox(height: 10),
          BlocProvider(
            create: (_) => _userBloc,
            child: BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                /*if (state is UserError) {
                          responseErrorWarning(context, state.message!);
                        }*/
              },
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoaded) {
                    return MakeAReservationForm(
                        createReservation: generateOrden);
                  } else {
                    return Center(
                      child: baseButtom(
                        onPressed: () => Navigator.pushNamed(context, 'login'),
                        text: const Text(
                          "Iniciar Sesion",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const Text(
            "Las evaluaciones y reseñas están verificadas y provienen de personas que usan el mismo tipo de dispositivo que usted.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  getCustomAttribute(
                          widget.data['custom_attributes'], 'product_score')
                      .toString(),
                  style: const TextStyle(fontSize: 50),
                ),
              ),
              const Expanded(
                flex: 7,
                child: Column(
                  children: [
                    RatingProgressIndicador(
                      text: '5',
                      value: 1.0,
                    ),
                    RatingProgressIndicador(
                      text: '4',
                      value: 0.8,
                    ),
                    RatingProgressIndicador(
                      text: '3',
                      value: 0.6,
                    ),
                    RatingProgressIndicador(
                      text: '2',
                      value: 0.4,
                    ),
                    RatingProgressIndicador(
                      text: '1',
                      value: 0.2,
                    )
                  ],
                ),
              )
            ],
          ),
          RatingBarIndicator(
            rating: double.parse(getCustomAttribute(
                    widget.data['custom_attributes'], 'product_score')
                .toString()),
            itemSize: 20,
            unratedColor: Colors.grey,
            itemBuilder: (_, __) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          const Text('12,600'),
          const SizedBox(
            height: 20,
          ),
          BlocProvider(
            create: (_) => _reviewBloc,
            child: BlocListener<ReviewsBloc, ReviewsState>(
              listener: (context, state) {
                /*if (state is UserError) {
                          responseErrorWarning(context, state.message!);
                        }*/
              },
              child: BlocBuilder<ReviewsBloc, ReviewsState>(
                builder: (context, state) {
                  if (state is ReviewsLoaded) {
                    if (state.data.result == 'fail') {
                      return const Center(
                          child: Text('No existen comentarios'));
                    }

                    return Column(
                      children: _createList(state.data.data!['data']),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final _dividerLine = const Divider(
    color: Colors.black,
    thickness: 1,
  );

  List<DropdownMenuItem<String>> timepostSlot(data) {
    List<DropdownMenuItem<String>> lista = [];
    if (data.runtimeType == List) {
      data.forEach((element) => {
            lista.add(DropdownMenuItem<String>(
              value: element['time'],
              child: Text(element['time']),
            ))
          });
    } else {
      data.forEach((ele, value) {
        lista.add(DropdownMenuItem<String>(
          value: value['time'],
          child: Text(value['time']),
        ));
      });
    }
    return lista;
  }

  List<Widget> _createList(datas) {
    List<Widget> lists = <Widget>[];
    for (dynamic data in datas) {
      print(data['detail']);
      lists.add(UsersReviewCard(data: data));
    }
    return lists;
  }
}

class RatingProgressIndicador extends StatelessWidget {
  const RatingProgressIndicador(
      {super.key, required this.text, required this.value});

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(text)),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: 20,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 15,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}

class UsersReviewCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const UsersReviewCard({super.key, required this.data});
  //const UsersReviewCard({Key? key}) : super(key: key, required this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/Profile.png'),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(data['nickname'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(
          width: 30,
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: 3,
              itemSize: 15,
              unratedColor: Colors.grey,
              itemBuilder: (_, __) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(data['created_at']),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                data['title'],
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: ReadMoreText(
              data['detail'],
              trimLines: 1,
              trimMode: TrimMode.Line,
              textAlign: TextAlign.left,
              trimExpandedText: ' Ver menos',
              trimCollapsedText: ' Ver mas',
              moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              lessStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            )),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
