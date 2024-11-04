import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utilities/constanst.dart';

class MapInfo extends StatefulWidget {
  const MapInfo({
    super.key,
    required this.hotelAddress,
    required this.location,
    //required this.lat,
    //required this.long,
    //required this.data
  });

  final String hotelAddress, location;
  //final double lat, long;
  //final Map<String, dynamic> data;

  //final List<dynamic> data;

  @override
  State<MapInfo> createState() => _MapInfoState();
}

class _MapInfoState extends State<MapInfo> with TickerProviderStateMixin {
  LatLng _marker = const LatLng(23.3231416, -103.8384764);
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(23.3231416, -103.8384764), zoom: 17);
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> getUserData() async {
    final splitter = widget.location.split(",");
    double lat = double.parse(splitter[0]);
    double lon = double.parse(splitter[1]);
    GoogleMapController controller = await _controller.future;
    _marker = LatLng(lat, lon);
    setState(() {
      controller
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lon), 17));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  widget.hotelAddress + " " + widget.location,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding * 2),
        SizedBox(
          height: 280,
          child: GoogleMap(
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              markers: {
                Marker(markerId: const MarkerId(""), position: _marker)
              }),
        ),
      ],
    ));
  }
}
