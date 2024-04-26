import 'package:flutter/material.dart';

class ModificacionRestaurante extends StatefulWidget {
  @override
  _ModificacionRestaurante createState() =>
      _ModificacionRestaurante();
}

class _ModificacionRestaurante
    extends State<ModificacionRestaurante> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _horariosController = TextEditingController();
  TextEditingController _tiposComidaController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificación de Datos del Restaurante'),
      ),
      body: Padding(
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ModificacionRestaurante(),
  ));
}
