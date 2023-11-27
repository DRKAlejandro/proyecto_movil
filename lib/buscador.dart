import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:proyecto_movil/geocoding.dart';

class Lugar {
  final String nombre;
  final double latitud;
  final double longitud;

  Lugar({required this.nombre, required this.latitud, required this.longitud});
}

class Buscador extends StatefulWidget {
  const Buscador({Key? key}) : super(key: key);

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  late double selectedPlaceLat;
  late double selectedPlaceLng;
  late int selectedPlaceIndex;
  late String selectedPlaceName;

  final List<Lugar> _lugares = [
    Lugar(nombre: 'Sendero', latitud: 22.130306, longitud: -100.925074),
    Lugar(nombre: 'Glorieta Juarez', latitud: 22.150697, longitud: -100.956398),
    Lugar(nombre: 'Centro', latitud: 22.150673, longitud: -100.9740704),
    Lugar(nombre: 'Plaza el Dorado', latitud: 22.155723, longitud: -101.004086),
    Lugar(
        nombre: 'Plaza Tangamanga',
        latitud: 22.139132,
        longitud: -101.001130),
    Lugar(
        nombre: 'Soriana el Paseo', latitud: 22.141201, longitud: -100.955118),
    Lugar(
        nombre: 'Jardín de Tequisquiapan',
        latitud: 22.150306,
        longitud: -100.992231),
    Lugar(
        nombre: 'Zona Universitaria',
        latitud: 22.148173,
        longitud: -101.014330),
    Lugar(
        nombre: 'Centro de Alto Rendimiento',
        latitud: 22.142182,
        longitud: -100.985995),
  ];

  @override
  void initState() {
    super.initState();
    selectedPlaceLat = 0.0;
    selectedPlaceLng = 0.0;
    selectedPlaceName = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: Text('Buscar'),
        backgroundColor: Colors.white,
        onSearch: (value) {
          setState(() {
            int selectedPlaceIndex =
                _lugares.indexWhere((lugar) => lugar.nombre == value);
            if (selectedPlaceIndex != -1) {
              selectedPlaceLat = _lugares[selectedPlaceIndex].latitud;
              selectedPlaceLng = _lugares[selectedPlaceIndex].longitud;
              selectedPlaceName = _lugares[selectedPlaceIndex].nombre;
            } else {
              selectedPlaceLat = 0.0;
              selectedPlaceLng = 0.0;
              selectedPlaceName = '';
            }
          });
        },
        suggestions: _lugares.map((lugar) => lugar.nombre).toList(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '$selectedPlaceName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Lat: $selectedPlaceLat, Lng: $selectedPlaceLng',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (selectedPlaceLat != 0.0 &&
                            selectedPlaceLng != 0.0) {
                          // Solo si se ha seleccionado un lugar
                          Navigator.pop(context, {
                            'nombre': selectedPlaceName,
                            'latitud': selectedPlaceLat,
                            'longitud': selectedPlaceLng,
                          });
                        } else {
                          //AlertDialog en caso de que no se ha seleccionado un destino
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Por favor, selecciona un destino válido.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('Confirmar'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mapa(
                              onLocationConfirmed: (locationData) {
                                setState(() {
                                  selectedPlaceName = locationData['nombre'];
                                  selectedPlaceLat = locationData['latitud'];
                                  selectedPlaceLng = locationData['longitud'];
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                        print(result);
                      },
                      child: Text('Buscar en el Mapa'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}