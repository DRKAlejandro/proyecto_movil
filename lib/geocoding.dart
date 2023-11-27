import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  final Function(Map<String, dynamic>) onLocationConfirmed;

  const Mapa({Key? key, required this.onLocationConfirmed}) : super(key: key);

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  late GoogleMapController mapController;

  late LatLng _center = const LatLng(22.149926, -100.997686);

  Marker? _selectedMarker;

  String _address = "";

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTapped(LatLng latLng) async {
    setState(() {
      _selectedMarker = null;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    String street =
        placemarks.isNotEmpty ? placemarks[0].thoroughfare ?? "" : "";
    String number =
        placemarks.isNotEmpty ? placemarks[0].subThoroughfare ?? "" : "";

    _address = "$street $number";

    setState(() {
      _selectedMarker = Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        onTap: () => _onMarkerTapped(latLng),
      );
    });
  }

  void _onMarkerTapped(LatLng latLng) {
    if (_selectedMarker != null) {
      _onMapTapped(latLng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _selectedMarker != null ? {_selectedMarker!} : {},
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            onTap: _onMapTapped,
          ),
          if (_selectedMarker != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ubicación: $_address'),
                      Text('Latitud: ${_selectedMarker!.position.latitude}'),
                      Text('Longitud: ${_selectedMarker!.position.longitude}'),
                      ElevatedButton(
                        onPressed: () {
                          widget.onLocationConfirmed({
                            'nombre': _address,
                            'latitud': _selectedMarker!.position.latitude,
                            'longitud': _selectedMarker!.position.longitude,
                          });
                          setState(() {
                            _selectedMarker = null;
                          });
                        },
                        child: Text('Confirmar Ubicación'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}