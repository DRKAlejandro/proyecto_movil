import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:proyecto_movil/fire_services.dart';
import 'package:proyecto_movil/geocoding.dart';

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

  List<Map<String, dynamic>> lugares_ = [];

  @override
  void initState() {
    super.initState();
    selectedPlaceLat = 0.0;
    selectedPlaceLng = 0.0;
    selectedPlaceName = '';
    inicializarDatosAsync();
    //lectura()
  }

  Future<void> inicializarDatosAsync() async {
    List<Map<String, dynamic>> puntos = await getPoints();
    print(puntos.toString());
    setState(() {
      lugares_ = puntos;
    });
  }

  Future<void> lectura() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: Text('Buscar'),
        backgroundColor: Colors.white,
        onSearch: (value) {
          setState(() {
            int selectedPlaceIndex =
                lugares_.indexWhere((lugar) => lugar['nombre'] == value);
            if (selectedPlaceIndex != -1) {
              selectedPlaceLat = lugares_[selectedPlaceIndex]['latitud'];
              selectedPlaceLng = lugares_[selectedPlaceIndex]['longitud'];
              selectedPlaceName = lugares_[selectedPlaceIndex]['nombre'];
            } else {
              selectedPlaceLat = 0.0;
              selectedPlaceLng = 0.0;
              selectedPlaceName = '';
            }
          });
        },
        suggestions:
            lugares_.map<String>((lugar) => lugar['nombre'] as String).toList(),
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