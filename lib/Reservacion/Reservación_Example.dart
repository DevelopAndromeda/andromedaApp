import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/bottomBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class ExampleReservacion extends StatefulWidget {
  ExampleReservacion({super.key});

  @override
  State<ExampleReservacion> createState() => _ExampleReservacionState();
}

class _ExampleReservacionState extends State<ExampleReservacion> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _personasController = TextEditingController();
  final _notasController = TextEditingController();

  final List<String> imagenes = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
    'assets/image4.jpg',
    'assets/image5.jpg',
  ];

  final String nombre = "Nombre del Restaurante";
  final String direccion = "Dirección del Restaurante";
  final String tipoComida = "Tipo de Comida";
  final String horarios = "Horarios de Servicio";
  final String descripcion =
      "Descripción del restaurante. Aquí puedes agregar una descripción detallada de lo que ofrece el restaurante.";

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información y Reserva del Restaurante'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                enableInfiniteScroll: true,
                viewportFraction: 0.8,
              ),
              items: imagenes.map((imagen) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Image.asset(
                        imagen,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    direccion,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tipo de Comida: $tipoComida',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Horarios de Servicio: $horarios',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Descripción:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    descripcion,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Realizar Reservación',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: Text(
                        "Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  ListTile(
                    title: Text("Hora: ${_selectedTime.format(context)}"),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                  TextField(
                    controller: _personasController,
                    decoration:
                        InputDecoration(labelText: 'Número de personas'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _notasController,
                    decoration: InputDecoration(
                        labelText: 'Notas adicionales (opcional)'),
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí puedes agregar la lógica para procesar la reserva
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Reserva Realizada'),
                            content:
                                Text('Tu reserva ha sido realizada con éxito.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Generar Reserva'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomBar(
        index: 2,
      ),
    );
  }
}
