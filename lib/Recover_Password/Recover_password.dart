import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({Key? key}) : super(key: key);

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Recuperar Contraseña'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  hintText: 'Ingrese su correo electrónico',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 154, 126, 43), // Cambia el color de fondo a dorado
                  foregroundColor: Color.fromARGB(255, 255, 255, 255), // Cambia el color del texto a blanco
                ),
                onPressed: () {
                  _resetPassword();
                },
                child: Text('Recuperar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor ingrese su correo electrónico'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Envía la solicitud de recuperación de contraseña a la API
    String apiUrl = 'https:'; // Reemplazar
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa (código 200), muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Solicitud de recuperación enviada a: $email'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Si la solicitud falla, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar la solicitud. Inténtalo de nuevo.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}