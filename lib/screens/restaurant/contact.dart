import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    } else {
      print(splitter.length);
      print('ver opciones de coors');
    }
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
        title: Text('Ubicacion'),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: GoogleMap(
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialPosition,
                markers: {Marker(markerId: MarkerId("Yo"), position: _marker)}),
          )
        ]),
      )),
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
