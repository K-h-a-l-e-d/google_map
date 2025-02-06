import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.title});

  final String title;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //Cairo Coordinates
  static const LatLng cairoLocationLatLng = LatLng(30.0444, 31.2357);

//initializing a red marker on cairo coordinates
  Marker cairoLocationMarker = Marker(
      markerId: MarkerId('Cairo'),
      position: cairoLocationLatLng,
      infoWindow: InfoWindow(title: 'Cairo Marker'));

  bool mapLoading = true;

  //initializing a google map controller object using Completer which creates the controller
  //as a future object to be used to move the camera position to cairo LatLng location
  //when pressing a button
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  //initializing camerta position which will be used as the initial camera position in
  //GoogleMap widget, also to be used in goToCairo function which moves the current camera postion
  //to cairo LatLng position
  static const CameraPosition cairoCameraPosition =
      CameraPosition(target: cairoLocationLatLng, zoom: 13);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType
            .hybrid, //detemining how the view is like (satellite or normal or hybrid)
        initialCameraPosition: cairoCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {cairoLocationMarker},
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCairo,
        label: const Text('Go To Cairo!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  //moves the camera position to cairo LatLng location
  Future<void> _goToCairo() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(cairoCameraPosition));
  }
}
