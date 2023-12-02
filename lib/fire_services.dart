import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getRoutes() async {

  List<Map<String, dynamic>> routes = [];

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
        print("Nombre ---");
        print(doc[rute]["Nombre"]);
        print("Puntos ---");
        print(doc[rute]["Puntos"]);

        String nombreRuta = doc[rute]["Nombre"];
        List<dynamic> puntosRuta = doc[rute]["Puntos"];

        List<LatLng> puntosLatLng = puntosRuta
          .map((punto) => LatLng(punto.latitude, punto.longitude))
          .toList();

        Map<String, dynamic> rutaMap = {'Nombre': nombreRuta, 'Puntos': puntosLatLng};
        routes.add(rutaMap);
      }
      print(routes.toString());
      print("aaaa");

      /*for (int i = 0; i < routes.length;i++){
        route_ = [];
        for(int j = 0; j < routes[i].length; j++){
          double latitude = routes[i][j].latitude;
          double longitude = routes[i][j].longitude;
          route_.add(LatLng(latitude,longitude));
        }
        print(route_.toString());
        routes_.add(route_);
      }
      print(routes_.toString());*/
    }
  }

  return routes;
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