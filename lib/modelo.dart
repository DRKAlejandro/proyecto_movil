final String table = 'my_table';

class ModelDataBase {
  static final List<String> values = [
    id,
    ruta,
    startLng,
    startLat,
    endLng,
    endLat,
  ];

  static final String id = 'id';
  static final String ruta = 'ruta';
  static final String startLng = 'startLng';
  static final String startLat = 'startLat';
  static final String endLng = 'endLng';
  static final String endLat = 'endLat';
}

class Model {
  int id;
  String ruta;
  double startLng;
  double startLat;
  double endLng;
  double endLat;

  Model({
    required this.id,
    required this.ruta,
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
  });

  factory Model.fromJson(Map<String, Object?> json) {
    return Model(
      id: json[ModelDataBase.id] as int,
      ruta: json[ModelDataBase.ruta] as String,
      startLng: json[ModelDataBase.startLng] as double,
      startLat: json[ModelDataBase.startLat] as double,
      endLng: json[ModelDataBase.endLng] as double,
      endLat: json[ModelDataBase.endLat] as double,
    );
  }

  Map<String, Object?> toJson() {
    return {
      ModelDataBase.id: id,
      ModelDataBase.ruta: ruta,
      ModelDataBase.startLng: startLng,
      ModelDataBase.startLat: startLat,
      ModelDataBase.endLng: endLng,
      ModelDataBase.endLat: endLat,
    };
  }
}
