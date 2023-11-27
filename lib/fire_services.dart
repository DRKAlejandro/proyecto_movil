import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<List<LatLng>>> getRoutes() async {

  List<List<dynamic>> routes = [];
  List<LatLng> route_ = [];
  List<List<LatLng>> routes_ = [];

  CollectionReference collectionReferenceRoutes = FirebaseFirestore.instance.collection('rutas');

  QuerySnapshot queryRoutes = await collectionReferenceRoutes.get();
  
  for (var doc in queryRoutes.docs) {

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data != null) {
      int numberOfFields = data.length;
      print("Número de campos en el documento: $numberOfFields");

      for (int i = 1; i < numberOfFields+1; i++){
        String rute = 'Ruta_' + i.toString();
        print(rute);
        print(doc[rute]);
        print(doc[rute].runtimeType);
        routes.add(doc[rute]);
      }
      print(routes.toString());

      for (int i = 0; i < routes.length;i++){
        route_ = [];
        for(int j = 0; j < routes[i].length; j++){
          double latitude = routes[i][j].latitude;
          double longitude = routes[i][j].longitude;
          route_.add(LatLng(latitude,longitude));
        }
        print(route_.toString());
        routes_.add(route_);
      }
      print(routes_.toString());
    }
  }

  return routes_;
}

Future<List<Map<String, dynamic>>> getPoints() async {
  List<Map<String, dynamic>> puntos = [];
  Map<String, dynamic> punto = {};
  CollectionReference collectionReferenceRoutes = FirebaseFirestore.instance.collection('lugares');

  QuerySnapshot queryRoutes = await collectionReferenceRoutes.get();

  for (var doc in queryRoutes.docs) {

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data != null) {
      int numberOfFields = data.length;
      print("Número de campos en el documento: $numberOfFields");

      for (int i = 1; i < numberOfFields+1; i++){
        String point = 'Punto_' + i.toString();
        print(point);
        punto = {
          "nombre": doc[point][0],
          "latitud": doc[point][1].latitude,
          "longitud": doc[point][1].longitude,
        };
        puntos.add(punto);
      }
      print(puntos.toString());
    }
  }
  return puntos;
}