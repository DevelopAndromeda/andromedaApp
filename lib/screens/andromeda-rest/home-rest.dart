import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/gps.dart';
import 'package:andromeda/services/db.dart';


//Uso de pruebas solamente
void main() {
  runApp(MyHomeRestPage());
}

class MyHomeRestPage extends StatefulWidget {
  const MyHomeRestPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomeRestPageState createState() => _MyHomeRestPageState();
}

class Restaurant{
  String nombre = '';
  String descripcion = '';
  String tipo = '';
  String direccion = '';
  String diaDeLaSemana = 'Lunes';
  String diaDeLaSemanaFin = 'Sábado';
  String horaInicio = '6:00 am';
  String horaFin = '11:00 pm';
}

class _MyHomeRestPageState extends State<MyHomeRestPage> {
  Future<void> getUserData() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isNotEmpty) {
      print(sesion[0]);
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Alta de Restaurante'),
        ),
        body: RestaurantForm(),
      ),
    );
  }
}

class RestaurantForm extends StatefulWidget {
  @override
  _RestaurantFormState createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  Restaurant _restaurant = Restaurant();

  List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  List<String> _timeOptions = [
    '6:00 am', '7:00 am', '8:00 am', '9:00 am', '10:00 am', '11:00 am',
    '12:00 pm', '1:00 pm', '2:00 pm', '3:00 pm', '4:00 pm', '5:00 pm',
    '6:00 pm', '7:00 pm', '8:00 pm', '9:00 pm', '10:00 pm', '11:00 pm'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre del Restaurante'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre del restaurante';
                }
                return null;
              },
              onSaved: (value) {
                _restaurant.nombre = value!;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descripción del Restaurante'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la descripción del restaurante';
                }
                return null;
              },
              onSaved: (value) {
                _restaurant.descripcion = value!;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Tipo de Restaurante'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el tipo de restaurante';
                }
                return null;
              },
              onSaved: (value) {
                _restaurant.tipo = value!;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Dirección del Restaurante'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la dirección del restaurante';
                }
                return null;
              },
              onSaved: (value) {
                _restaurant.direccion = value!;
              },
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _restaurant.diaDeLaSemana,
                    items: _daysOfWeek.map((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Día de Inicio'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _restaurant.diaDeLaSemana = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _restaurant.diaDeLaSemanaFin,
                    items: _daysOfWeek.map((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Día de Fin'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _restaurant.diaDeLaSemanaFin = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text('Horario de Servicio:'),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _restaurant.horaInicio,
                    items: _timeOptions.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Inicio'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _restaurant.horaInicio = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _restaurant.horaFin,
                    items: _timeOptions.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Fin'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _restaurant.horaFin = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Aquí puedes guardar los datos del restaurante en la base de datos
                  print('Datos del restaurante:');
                  print('Nombre: ${_restaurant.nombre}');
                  print('Descripción: ${_restaurant.descripcion}');
                  print('Tipo: ${_restaurant.tipo}');
                  print('Dirección: ${_restaurant.direccion}');
                  print('Días de la semana abiertos: ${_restaurant.diaDeLaSemana} - ${_restaurant.diaDeLaSemanaFin}');
                  print('Hora de inicio: ${_restaurant.horaInicio}');
                  print('Hora de fin: ${_restaurant.horaFin}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Restaurante registrado correctamente'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Registrar Restaurante'),
            ),
          ],
        ),
      ),
    );
  }
}
