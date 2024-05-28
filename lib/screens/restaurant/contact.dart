import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:andromeda/utilities/constanst.dart';

class MyContactPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const MyContactPage({super.key, required this.data});

  @override
  State<MyContactPage> createState() => _MyContactPageState();
}

class _MyContactPageState extends State<MyContactPage> {
  LatLng _marker = LatLng(23.3231416, -103.8384764);
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(23.3231416, -103.8384764));
  Completer<GoogleMapController> _controller = Completer();

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
    } //else {
    //print(splitter.length);
    //print('ver opciones de coors');
    //}
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.data['name'],style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              'Detalles',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Direccion del restaurante',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              getCustomAttribute(
                  widget.data['custom_attributes'], 'hotel_address'),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: GoogleMap(
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialPosition,
                markers: {
                  Marker(markerId: const MarkerId("Yo"), position: _marker)
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              'Informacion adicional',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: const [
                Icon(Icons.phone),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Telefono',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                const SizedBox(
                  width: 44,
                ),
                Text(
                  '${getCustomAttribute(widget.data['custom_attributes'], 'restaurant_number')}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: const [
                Icon(Icons.coffee),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Cocina',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                const SizedBox(
                  width: 44,
                ),
                Text(
                  getCustomAttribute(
                      widget.data['custom_attributes'], 'category_string'),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ]),
      )),
    );
  }
}
