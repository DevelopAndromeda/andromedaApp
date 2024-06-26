import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/login/login_bloc.dart';

import 'package:andromeda/witgets/button_base.dart';
import 'package:andromeda/witgets/Colores_Base.dart';

import 'package:andromeda/utilities/constanst.dart';
import 'package:andromeda/utilities/strings.dart';

class MyRecoverPassword extends StatefulWidget {
  const MyRecoverPassword({Key? key}) : super(key: key);

  @override
  State<MyRecoverPassword> createState() => _MyRecoverPasswordState();
}

class _MyRecoverPasswordState extends State<MyRecoverPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 117, 117, 117), // Color del contorno
            width: 1.0, // Grosor del contorno
          ),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        labelText: 'Correo Electrónico',
        hintText: 'Ingrese su correo electrónico',
        labelStyle: const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
        suffixIcon: const Icon(Icons.email_outlined),
        enabledBorder: OutlineInputBorder(
          // Estilo de contorno cuando está habilitado
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 0, 0), // Color del contorno
            width: 2.0, // Grosor del contorno
          ),
        ),
        focusedBorder: OutlineInputBorder(
          // Estilo de contorno cuando está enfocado
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(
                255, 0, 0, 0), // Color del contorno al estar enfocado
            width: 2.0, // Grosor del contorno al estar enfocado
          ),
        ),
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
    );
  }

  Container buttonRecovery() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 58, vertical: 30),
      child: baseButtom(onPressed: () async {
        if (_formKey.currentState!.validate()) {
          context
              .read<AuthLogic>()
              .recoveryLogic(_emailController.text, context);
        } else {
          responseErrorWarning(context, MyString.required);
          return;
        }
      }, text: BlocBuilder<AuthLogic, AuthState>(builder: (context, state) {
        if (state is RecoveryLoadingState) {
          return state.isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text("Recuperar Contraseña",
                  style: TextStyle(fontSize: 14, color: Colors.white));
        } else {
          return const Text(
            "Recuperar Contraseña",
            style: TextStyle(fontSize: 14, color: Colors.white),
          );
        }
      })),
    );
  }

  Form _form() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[emailInput(), buttonRecovery()],
        ),
      ),
    );
  }
}
