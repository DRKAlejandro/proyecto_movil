import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<List<LatLng>>> getRoutes() async {
  List<LatLng> route_ = [];
  List<List<LatLng>> routes_ = [];

  CollectionReference collectionReferenceRoutes = FirebaseFirestore.instance.collection('rutas');

  QuerySnapshot queryRoutes = await collectionReferenceRoutes.get();
  
  for (var doc in queryRoutes.docs) {

    /*Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data != null) {
      int numberOfFields = data.length;
      print("Número de campos en el documento: $numberOfFields");

      for(int i = 0; i<numberOfFields; i++) {
        for(int j = 0; j < data[i].length; j++){
          print(data[i][j].latitude.toString());
        }
      }
    }*/
    List<dynamic> ruta1Data = doc['Ruta_1'];
    List<dynamic> ruta2Data = doc['Ruta_2'];

    print("Ruta1Data = " + ruta1Data[0].latitude.toString());
    print("Ruta1Data = " + ruta1Data.length.toString());

    for (int i = 0; i < ruta1Data.length;i++){
      double latitude = ruta1Data[i].latitude;
      double longitude = ruta1Data[i].longitude;
      route_.add(LatLng(latitude,longitude));
    }
    routes_.add(route_);
    print(routes_.toString());
    route_ = [];

    for (int i = 0; i < ruta2Data.length;i++){
      double latitude = ruta2Data[i].latitude;
      double longitude = ruta2Data[i].longitude;
      route_.add(LatLng(latitude,longitude));
    }
    routes_.add(route_);
    print(routes_.toString());
    print("Ruta 1 = " + routes_[0].toString());
    print("Ruta 2 = " + routes_[1].toString());

    //routes.add(route);
  }

  return routes_;
}

