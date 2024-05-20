import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/services/api.dart';

class MyRecoverPassword extends StatefulWidget {
  const MyRecoverPassword({Key? key}) : super(key: key);

  @override
  State<MyRecoverPassword> createState() => _MyRecoverPasswordState();
}

class _MyRecoverPasswordState extends State<MyRecoverPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: Text("Recuperar Contraseña",
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: BackButton(color: Colors.white,),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
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
            SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 0, 0), // Cambia el color de fondo a dorado
                foregroundColor: Color.fromARGB(
                    255, 255, 255, 255),
                     shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4), // Modifica el radio de borde según sea necesario
    ), // Cambia el color del texto a blanco
              ),
              onPressed: () {
                _resetPassword();
              },
              child: Text('Recuperar Contraseña'),
            ),
          ],
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

    Map<String, dynamic> data = {
      "email": _emailController.text,
      "template": "email_reset"
    };

    try {
      final updatePassword =
          await put('', 'type', 'customers/', data, 'password');

      if (updatePassword != null) {
        if (updatePassword) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Recuperacion Exitosa")));
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
