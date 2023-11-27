/*import 'package:examenlll/database.dart';
import 'package:examenlll/modelo.dart';
import 'package:flutter/material.dart';
import 'package:examenlll/getApi.dart';

TextEditingController nombreController = TextEditingController();
TextEditingController apellidoPaternoController = TextEditingController();
TextEditingController apellidoMaternoController = TextEditingController();
TextEditingController edadController = TextEditingController();
TextEditingController paisOrigenController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController telefonoController = TextEditingController();
TextEditingController calificacionController = TextEditingController();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await dbHelper.deleteAllModels();
                  getJsonData();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Solicitar nuevos usuarios',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Widget>>(
                  future: _buildCards(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error al cargar los datos');
                    } else {
                      return ListView(
                        children: snapshot.data!,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> _buildCards() async {
    List<Widget> cards = [];

    final List<Model> models = await dbHelper.getModels();

    for (int i = 0; i < models.length; i++) {
      Color cardColor;
      double fontSize = 15.0;
      Color textColor = Colors.red;
      Color textColor2 = Colors.black;

      if (models[i].calificacion > 80) {
        fontSize = 20.0;
        textColor = Colors.green;
      } else if (models[i].calificacion > 60) {
        fontSize = 18.0;
        textColor = Colors.orange;
      }
      List<String> paisesContinenteAmericano = [
        'Estados Unidos',
        'Canadá',
        'Uruguay',
        'Argentina',
        'Brasil',
        'México',
        'Colombia',
        'Chile',
        'Perú',
        'Venezuela',
        'Ecuador',
        'Paraguay',
        'Bolivia',
        'Guatemala',
        'Cuba',
        'Honduras',
        'Nicaragua',
        'El Salvador',
        'Costa Rica',
        'Panamá',
        'República Dominicana',
        'Puerto Rico',
        'Jamaica',
        'Haití',
      ];

      if (models[i].paisOrigen == 'México') {
        cardColor = Color.fromARGB(255, 9, 191, 215);
      } else if (paisesContinenteAmericano.contains(models[i].paisOrigen)) {
        cardColor = Colors.green;
      } else {
        cardColor = Colors.black;
        textColor2 = Colors.white;
      }

      cards.add(
        Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.person, color: textColor2),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          '${models[i].nombre}',
                          style: TextStyle(fontSize: 20, color: textColor2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${models[i].apellidoPaterno}',
                          style: TextStyle(fontSize: 20, color: textColor2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${models[i].apellidoMaterno}',
                          style: TextStyle(fontSize: 20, color: textColor2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${models[i].email}',
                          style: TextStyle(color: textColor2),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '${models[i].telefono}',
                          style: TextStyle(color: textColor2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${models[i].calificacion}',
                        style: TextStyle(fontSize: fontSize, color: textColor),
                      ),
                      Text(
                        '${models[i].edad}',
                        style: TextStyle(color: textColor2),
                      ),
                      Text(
                        '${models[i].paisOrigen}',
                        style: TextStyle(color: textColor2),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.update,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      nombreController.text = models[i].nombre;
                      apellidoPaternoController.text =
                          models[i].apellidoPaterno;
                      apellidoMaternoController.text =
                          models[i].apellidoMaterno;
                      edadController.text = models[i].edad.toString();
                      paisOrigenController.text = models[i].paisOrigen;
                      telefonoController.text = models[i].telefono;
                      emailController.text = models[i].email;
                      calificacionController.text =
                          models[i].calificacion.toString();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Actualizar Datos'),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: nombreController,
                                    decoration:
                                        InputDecoration(labelText: 'Nombre'),
                                    onChanged: (value) {},
                                  ),
                                  TextField(
                                    controller: apellidoPaternoController,
                                    decoration: InputDecoration(
                                        labelText: 'Apellido Paterno'),
                                  ),
                                  TextField(
                                    controller: apellidoMaternoController,
                                    decoration: InputDecoration(
                                        labelText: 'Apellido Materno'),
                                  ),
                                  TextField(
                                    controller: edadController,
                                    decoration:
                                        InputDecoration(labelText: 'Edad'),
                                  ),
                                  TextField(
                                    controller: paisOrigenController,
                                    decoration: InputDecoration(
                                        labelText: 'País de Origen'),
                                  ),
                                  TextField(
                                    controller: telefonoController,
                                    decoration:
                                        InputDecoration(labelText: 'Teléfono'),
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration:
                                        InputDecoration(labelText: 'Email'),
                                  ),
                                  TextField(
                                    controller: calificacionController,
                                    decoration: InputDecoration(
                                        labelText: 'Calificación'),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final updatedModel = Model(
                                    id: models[i].id,
                                    nombre: nombreController.text,
                                    apellidoPaterno:
                                        apellidoPaternoController.text,
                                    apellidoMaterno:
                                        apellidoMaternoController.text,
                                    edad:
                                        int.tryParse(edadController.text) ?? 0,
                                    paisOrigen: paisOrigenController.text,
                                    telefono: telefonoController.text,
                                    email: emailController.text,
                                    calificacion: int.tryParse(
                                            calificacionController.text) ??
                                        0,
                                  );
                                  dbHelper.updateModel(updatedModel);

                                  setState(() {
                                    models[i] = updatedModel;
                                  });

                                  Navigator.pop(context);
                                },
                                child: Text('Actualizar'),
                              ),
                            ],
                          );
                        },
                      );
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmación'),
                            content: Text('¿Deseas eliminar?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await dbHelper.deleteModel(models[i].id);
                                  setState(() {
                                    models.removeAt(i);
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return cards;
  }

  Future<void> getJsonData() async {
    Alumno alumno =
        Alumno(nombre: 'Alejandro Alonso', clave: '327028', hora: '7-8');

    try {
      var data;
      data = await alumno.getDatos();
      if (data['estatus'] == 200) {
        print(data);
        print(data['estatus']);
        print(data['respuesta']);
        print(data['respuesta'][1]);
        print(data['respuesta'][1]['nombre']);
        print(data['respuesta'][1]['apellido_paterno']);
        print(data['respuesta'][1]['apellido_materno']);
        print(data['respuesta'][1]['edad']);
        print(data['respuesta'][1]['pais_origen']);
        print(data['respuesta'][1]['telefono']);
        print(data['respuesta'][1]['email']);
        print(data['respuesta'][1]['calificacion']);
        for (int i = 0; i < lengthList(data['respuesta']); i++) {
          final model = Model(
            id: DateTime.now().millisecondsSinceEpoch,
            nombre: data['respuesta'][i]['nombre'],
            apellidoPaterno: data['respuesta'][i]['apellido_paterno'],
            apellidoMaterno: data['respuesta'][i]['apellido_paterno'],
            edad: data['respuesta'][i]['edad'],
            paisOrigen: data['respuesta'][i]['pais_origen'],
            telefono: data['respuesta'][i]['telefono'],
            email: data['respuesta'][i]['email'],
            calificacion: data['respuesta'][i]['calificacion'],
          );

          await dbHelper.insertModel(model);
        }
        print('TODOS LOS DATOS INSERTADOS');
        setState(() {});
      } else {
        print('Lista vacia');
      }
    } catch (e) {
      print('Hubo un error al extraer los datos');
    }

    setState(() {});
  }

  int lengthList(var list) {
    int num = 0;
    try {
      for (var cad in list) {
        num = num + 1;
      }
    } catch (e) {
      num = 0;
    }
    return num;
  }
}
*/