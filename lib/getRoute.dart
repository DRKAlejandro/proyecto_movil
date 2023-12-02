import 'dart:math';
import 'fire_services.dart';

/*List<LatLng> points_R1 = [
  LatLng(22.151058, -100.982223),
  LatLng(22.148809, -101.010965),
  LatLng(22.146862, -101.010784),
  LatLng(22.138190, -100.987787),
  LatLng(22.148334, -100.983277),
  LatLng(22.148625, -100.981115),
  LatLng(22.149714, -100.981673),
  LatLng(22.151577, -100.981950),
  LatLng(22.151668, -100.982244),
  LatLng(22.151058, -100.982223),
];

List<LatLng> points_R2 = [
  LatLng(22.149778, -100.955675),
  LatLng(22.125708, -100.919225),
  LatLng(22.128495, -100.917382),
  LatLng(22.146330, -100.916295),
  LatLng(22.148003, -100.915681),
  LatLng(22.150449, -100.914381),
  LatLng(22.154826, -100.914483),
  LatLng(22.151419, -100.955079),
  LatLng(22.149778, -100.955675),
];*/

List<Map<String, dynamic>> combinedRoutes = [];//[points_R1, points_R2];
List<double> routeShortDistance= [];
int bestRoute = -1;

class Distance{
  final double latitudPointA;
  final double longitudPointA;

  Distance({required this.latitudPointA, required this.longitudPointA});

  /*void combineRoute(){
    combinedRoutes = [points_R1, points_R2];
  }*/

  Future<List<Map<String, dynamic>>> getRoute() async {
    try {
      List<Map<String, dynamic>> routes = await getRoutes();
      print (routes);
      print ("Tamaño de routes = " + routes.length.toString());
      return routes;
    } catch (e) {
      print('Error al obtener rutas: $e');
      return []; // o maneja el error de alguna otra manera
    }
  }
  

  int numRoute(){
    return bestRoute;
  }

  double calculateDistance(latitudPointB, longitudPointB){
    print("LatA " + latitudPointA.toString() + " LongA " + longitudPointA.toString() + 
          " LatB " + latitudPointB.toString() + " LongB " + longitudPointB.toString());
    var p = 0.017453292519943295;
    var a = 0.5 - cos((latitudPointB - latitudPointA) * p)/2 + 
          cos(latitudPointA * p) * cos(latitudPointB * p) * 
          (1 - cos((longitudPointB - longitudPointA) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<Map<String, dynamic>> calculateRoute () async {
    combinedRoutes = await getRoute();
    print(combinedRoutes);
    print(combinedRoutes[0]);
    print(combinedRoutes[0]["Nombre"]);
    print(combinedRoutes[0]["Puntos"].length);
    print(combinedRoutes[0]["Puntos"][0]);
    print(combinedRoutes[0]["Puntos"][0]);
    print(combinedRoutes[0]["Puntos"][0].latitude);
    print(combinedRoutes[0]["Puntos"][0].longitude);
    print(combinedRoutes.toList().toString());
    for (int i = 0; i < combinedRoutes.length; i++) {
      double distance = 100.0;
      routeShortDistance.add(distance);
      print("Route " + i.toString());
      for (int j = 0; j < combinedRoutes[i]["Puntos"].length; j++) {
        double latitude = combinedRoutes[i]["Puntos"][j].latitude;
        double longitude = combinedRoutes[i]["Puntos"][j].longitude;
        distance = calculateDistance(latitude, longitude);
        print("distance: " + distance.toString());
        if(distance < routeShortDistance[i]){
          routeShortDistance[i] = distance;
        }
      }
    }

    print(routeShortDistance.toString());

    double minDistance = 100.0;
    bestRoute = -1;
    for (int i = 0; i < combinedRoutes.length; i++) {
      if(routeShortDistance[i] < minDistance){
        minDistance = routeShortDistance[i];
        bestRoute = i;
      }
    }
    print("Mejor ruta = " + bestRoute.toString() + "minDistancia = " + minDistance.toString());
    print(combinedRoutes[bestRoute]);
    routeShortDistance.clear();
    //return combinedRoutes[bestRoute];
    return combinedRoutes[bestRoute];
  }
} 