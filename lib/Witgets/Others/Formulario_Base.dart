import 'package:flutter/material.dart';

class FormularioBase extends StatefulWidget {
  @override
  _FormularioBaseState createState() => _FormularioBaseState();
}

class _FormularioBaseState extends State<FormularioBase> {
  // Controladores para los campos de texto
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _tipoComidaController = TextEditingController();
  TextEditingController _horarioAperturaController = TextEditingController();
  TextEditingController _horariosDiasController = TextEditingController();

  // Método para manejar la lógica de envío del formulario
  void _enviarFormulario() {
    // Aquí puedes implementar la lógica para procesar la información del formulario
    // Puedes acceder a los valores ingresados a través de los controladores
    // _nombreController.text, _usuarioController.text, etc.

    // Por ahora, simplemente imprimimos los valores en la consola
    print("Nombre: ${_nombreController.text}");
    print("Usuario: ${_usuarioController.text}");
    print("Correo: ${_correoController.text}");
    print("Teléfono: ${_telefonoController.text}");
    print("Descripción: ${_descripcionController.text}");
    print("Tipo de Comida: ${_tipoComidaController.text}");
    print("Horario de Apertura: ${_horarioAperturaController.text}");
    print("Horarios de Días: ${_horariosDiasController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Restaurantes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _crearCampoTexto("Nombre", _nombreController),
              _crearCampoTexto("Usuario", _usuarioController),
              _crearCampoTexto("Correo", _correoController),
              _crearCampoTexto("Teléfono", _telefonoController),
              _crearCampoTexto("Descripción", _descripcionController),
              _crearCampoTexto("Tipo de Comida", _tipoComidaController),
              _crearCampoTexto("Horario de Apertura", _horarioAperturaController),
              _crearCampoTexto("Horarios de Días", _horariosDiasController),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _enviarFormulario,
                child: Text('Registrar Restaurante'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para crear un campo de texto reutilizable
  Widget _crearCampoTexto(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FormularioBase(),
  ));
}
