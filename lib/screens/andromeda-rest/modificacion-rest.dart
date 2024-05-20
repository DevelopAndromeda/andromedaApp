import 'package:flutter/material.dart';
import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';

class ModificacionRestaurante extends StatefulWidget {
  const ModificacionRestaurante({super.key, required this.data});
  final Map<dynamic, dynamic> data;

  @override
  _ModificacionRestaurante createState() => _ModificacionRestaurante();
}

class _ModificacionRestaurante extends State<ModificacionRestaurante> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _pais = TextEditingController();
  final TextEditingController _estado = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _max_capacity = TextEditingController();
  final TextEditingController _slot_duration = TextEditingController();
  final TextEditingController _prevent_scheduling_before =
      TextEditingController();
  final TextEditingController _break_time_bw_slot = TextEditingController();
  final List<Map<String, dynamic>> _daysOfWeek = [
    {
      'name': 'Lunes',
      'checked': false,
      'index': 1,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Martes',
      'checked': false,
      'index': 2,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Miercoles',
      'checked': false,
      'index': 3,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Jueves',
      'checked': false,
      'index': 4,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Viernes',
      'checked': false,
      'index': 5,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Sabado',
      'checked': false,
      'index': 6,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    },
    {
      'name': 'Domingo',
      'checked': false,
      'index': 7,
      'hora': [
        {'from': '6:00 am', 'to': '3:00 pm'},
      ]
    }
  ];
  late Future<List<dynamic>> Estados;
  List<String> _timeOptions = [
    '6:00 am',
    '7:00 am',
    '8:00 am',
    '9:00 am',
    '10:00 am',
    '11:00 am',
    '12:00 pm',
    '1:00 pm',
    '2:00 pm',
    '3:00 pm',
    '4:00 pm',
    '5:00 pm',
    '6:00 pm',
    '7:00 pm',
    '8:00 pm',
    '9:00 pm',
    '10:00 pm',
    '11:00 pm'
  ];
  List<String> Paises = ['México'];
  Future<void> getUserData() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

    if (sesion.isNotEmpty) {
      print(sesion[0]);
    }

    _nombreController.text = widget.data['name'];
    _descripcionController.text = getCustomAttribute(
        widget.data['custom_attributes'], 'short_description');
    _direccionController.text =
        getCustomAttribute(widget.data['custom_attributes'], 'hotel_address');
    setState(() {});
  }

  Future<List<dynamic>> setStates() async {
    //Llenar base de datos local
    final estadosEndpoint = await get('', '', 'states?countryCode=MX');
    if (estadosEndpoint == null) {
      print('no hay datos en endpoint');
      return [];
    }

    print('Regresamos');
    print(estadosEndpoint['items']);
    return estadosEndpoint['items'];
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    Estados = setStates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Background_Color,
        appBar: AppBar(
          title: Text('Modificación',),
          centerTitle: true,
          leading: BackButton(),
          elevation: 1,
          backgroundColor: Colors.black12,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                              labelText: 'Nombre del Restaurante'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese el nombre del restaurante';
                            }
                            return null;
                          }),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: InputDecoration(
                            labelText: 'Descripción del Restaurante'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la descripción del restaurante';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                          controller: _tipoController,
                          decoration:
                              InputDecoration(labelText: 'Tipo de Restaurante'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese el tipo de restaurante';
                            }
                            return null;
                          }),
                      SizedBox(height: 20.0),
                      Text(
                        'Informacion de Contacto',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 10.0),
                      Row(children: <Widget>[
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: DropdownButtonFormField<String>(
                            //value: _pais.text,
                            items: Paises.map((String time) {
                              return DropdownMenuItem<String>(
                                value: time,
                                child: Text(time),
                              );
                            }).toList(),
                            decoration: InputDecoration(labelText: 'Pais'),
                            onChanged: (String? newValue) {
                              setState(() {
                                _pais.text = newValue!;
                              });
                            },
                          ),
                        )),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: FutureBuilder<List<dynamic>>(
                                future: Estados,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    print(snapshot.data);
                                    return DropdownButtonFormField<String>(
                                      items: snapshot.data!.map((element) {
                                        return DropdownMenuItem<String>(
                                          value: element['id'].toString(),
                                          child:
                                              Text(element['label'].toString()),
                                        );
                                      }).toList(),
                                      decoration:
                                          InputDecoration(labelText: 'Estado'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _estado.text = newValue!;
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }

                                  // By default, show a loading spinner.
                                  return const CircularProgressIndicator();
                                }),
                          ),
                        ),
                      ]),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _direccionController,
                        decoration: InputDecoration(
                            labelText: 'Dirección del Restaurante'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la dirección del restaurante';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton( onPressed: () {  },
                      child: const Text('Modificar')),
                    ],
                  ))
                  
                  
                 
                  ),
        )
        /*Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextFormField(
              controller: _horariosController,
              decoration: InputDecoration(labelText: 'Horarios de Servicio'),
            ),
            TextFormField(
              controller: _tiposComidaController,
              decoration: InputDecoration(labelText: 'Tipos de Comida'),
            ),
            TextFormField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña de Usuario'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para guardar los datos modificados
                // Puedes acceder a los valores utilizando los controladores
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),*/
        );
  }

  getCustomAttribute(data, type) {
    if (data.length == 0) {
      return '';
    }

    Map<String, String> typeValue = {'product_score': '0'};
    String? value = typeValue[type] ?? '';
    for (dynamic attr in data) {
      if (attr['attribute_code'] == type) {
        value = attr['value'];
      }
    }
    return value;
  }
}
