import 'package:proyecto_movil/buscador.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyecto_movil/getRoute.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;

  LatLng _center = LatLng(22.149926, -100.997686);
  String nombreRuta = '';
  String lugarDestino = '';
  double latDestino = 0.0;
  double lngDestino = 0.0;
  //Guardar los puntos con las coordenadas (lat, lng)
  List<LatLng> polyPoints = [];
  //Guardar las lineas sobre el mapa
  Set<Polyline> polyLines = {};
  // Lista de marcadores
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    setCustomMarkerIcon();
    super.initState();
    _getUserLocation();
  }

  _getUserLocation() async {
    Location location = new Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    LocationData locationData = await location.getLocation();
    setState(() {
      _center = LatLng(locationData.latitude!, locationData.longitude!);
      _markers.add(
        Marker(
          markerId: MarkerId('Mi ubicacion'),
          position: _center,
        ),
      );
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          _center,
          15,
        ),
      );
    });
  }

  void setMarkers(){

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //Imagen -> Marca para visualizar el mapa
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "").then(
      (icon) {
        sourceIcon = icon;
      },
    );
  }

  void actualizaCoordenadas(String lat, String lng) {
    _center = LatLng(double.parse(lat), double.parse(lng));
  }

  setPolyLines() {
    polyLines.clear();
    setState(() {
      ///p1 --------- p2 ------- p3
      Polyline polyline = Polyline(
          polylineId: const PolylineId('polilyne'),
          color: Colors.red,
          width: 5,
          points: polyPoints);
      polyLines.add(polyline);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController =
                  controller; // INICIALIZACION DEL MAPCONTROLLER ANTES DEL MAPA
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            zoomControlsEnabled: false,
            polylines: polyLines,
            markers: _markers, // MARKER
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                child: FittedBox(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 22, 0, 108)),
                    ),
                    label: const Text(
                      'Buscar',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Map<String, dynamic>? result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Buscador()),
                      );
                      if (result != null) {
                        Distance _distance = Distance(latitudPointA: result['latitud'], longitudPointA: result['longitud']);
                        Map<String, dynamic>? route = await _distance.calculateRoute();
                        print(route.toString());
                        polyPoints = [];
                        polyPoints = route["Puntos"];
                        print("Polypoints = " + polyPoints.toString());
                        setPolyLines();
                        setState(() {
                          lugarDestino = result['nombre'];
                          latDestino = result['latitud'];
                          lngDestino = result['longitud'];
                          nombreRuta = route["Nombre"];

                          // Limpiar los marcadores existentes antes de agregar uno nuevo
                          _markers.clear();
                          // Agregar un nuevo marcador
                          _markers.add(
                            Marker(
                              markerId: MarkerId('destination'),
                              position: LatLng(latDestino, lngDestino),
                              infoWindow: InfoWindow(
                                title: lugarDestino,
                              ),
                            ),
                          );
                          //MOVER CAMARA A LA POSICION DEL MARKER
                          mapController.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              LatLng(latDestino, lngDestino),
                              15,
                            ),
                          );
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          SlidingUpPanel(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            minHeight: 70,
            panel: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Text('$lugarDestino',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('$nombreRuta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            )
          ),
        ],
      ),
    );
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}