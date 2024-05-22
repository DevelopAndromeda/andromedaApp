import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/services/api.dart';

import 'package:andromeda/utilities/constanst.dart';

class MyRecoverPassword extends StatefulWidget {
  const MyRecoverPassword({Key? key}) : super(key: key);

  @override
  State<MyRecoverPassword> createState() => _MyRecoverPasswordState();
}

class _MyRecoverPasswordState extends State<MyRecoverPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Background_Color,
        appBar: AppBar(
          title: const Text(
            "Recuperar Contraseña",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: const BackButton(
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 1,
        ),
        body: _form());
  }

  Form _form() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'Ingrese su correo electrónico',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su correo electrónico';
                }

                String? isValid = validateEmail(value);
                if (isValid != null) {
                  return isValid;
                }

                return null;
              },
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 0, 0, 0), // Cambia el color de fondo a dorado
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      4), // Modifica el radio de borde según sea necesario
                ), // Cambia el color del texto a blanco
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _resetPassword();
                }
              },
              child: const Text('Recuperar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword() async {
    Map<String, dynamic> data = {
      "email": _emailController.text.trim(),
      "template": "email_reset"
    };

    try {
      final updatePassword =
          await put('', 'type', 'customers/', data, 'password');

      if (updatePassword != null) {
        if (updatePassword) {
          responseSuccessWarning(
              context, 'Te hemos enviado un correo electronico');
        }
      }
    } catch (e) {
      responseErrorWarning(context, e.toString());
    }
  }
}
