import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/blocs/user/user_sesion_bloc.dart';

import '../../witgets/boton_base.dart';

class MyChangePasswordPage extends StatefulWidget {
  const MyChangePasswordPage({super.key});

  @override
  State<MyChangePasswordPage> createState() => _MyChangePasswordPagePageState();
}

class _MyChangePasswordPagePageState extends State<MyChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _lastPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool typePasswordLast = true;
  bool typePasswordNew = true;
  bool typePasswordConfirm = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? validatePasswords() {
    return _newPasswordController.text != _confirmPasswordController.text
        ? 'Las contraseñas no coinciden'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cambiar Contraseña',
            style: TextStyle(
              fontSize: 24, // Tamaño de fuente (puedes ajustarlo)
              color: Colors.white, // Texto blanco
              fontWeight: FontWeight.bold, // Negrita
            ),
          ),
          leading: BackButton(
            onPressed: () => Navigator.pushNamed(context, 'profile'),
            color: Colors.white,
          ),
          elevation: 1,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(child: _form()));
  }

  Form _form() {
    return Form(
      key: _formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20),
        lastPasswordInput(),
        const SizedBox(height: 15),
        newPasswordInput(),
        const SizedBox(height: 15),
        confirPassworInput(),
        const SizedBox(height: 15),
        createButton()
      ]),
    );
  }

  Container lastPasswordInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _lastPasswordController,
        obscureText: typePasswordLast,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          label: const Text(
            'Contraseña Actual',
            style: TextStyle(color: Colors.grey),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                typePasswordLast = !typePasswordLast;
              });
            },
            child: Icon(typePasswordLast == true
                ? Icons.lock_outline
                : Icons.lock_open),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0), // Borde negro cuando está habilitado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0), // Borde negro más grueso cuando está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingresa tu contraseña';
          }

          String? isValid = validatePasswords();
          if (isValid != null) {
            return isValid;
          }

          return null;
        },
      ),
    );
  }

  Container newPasswordInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _newPasswordController,
        obscureText: typePasswordNew,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          label: const Text(
            'Nueva Contraseña',
            style: TextStyle(color: Colors.grey),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                typePasswordNew = !typePasswordNew;
              });
            },
            child: Icon(
                typePasswordNew == true ? Icons.lock_outline : Icons.lock_open),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0), // Borde negro cuando está habilitado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0), // Borde negro más grueso cuando está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingresa tu contraseña';
          }

          String? isValid = validatePasswords();
          if (isValid != null) {
            return isValid;
          }

          return null;
        },
      ),
    );
  }

  Container confirPassworInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: typePasswordConfirm,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          label: const Text(
            'Confirmar contraseña',
            style: TextStyle(color: Colors.grey),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                typePasswordConfirm = !typePasswordConfirm;
              });
            },
            child: Icon(typePasswordConfirm == true
                ? Icons.lock_outline
                : Icons.lock_open),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0), // Borde negro cuando está habilitado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0), // Borde negro más grueso cuando está enfocado
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingresa tu contraseña';
          }

          String? isValid = validatePasswords();
          if (isValid != null) {
            return isValid;
          }
          return null;
        },
      ),
    );
  }

  Container createButton() {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: MyBaseButtom(onPressed: () async {
          //print('aca');
          if (_formKey.currentState!.validate()) {
            try {
              context.read<UserSesionLogic>().updatePasswordLogic({
                'currentPassword': _lastPasswordController.text,
                'newPassword': _newPasswordController.text,
              }, context);
            } catch (E) {
              //print(E);
            }
          }
        }, text: BlocBuilder<UserSesionLogic, UserSesionState>(
            builder: (context, state) {
          if (state is UserLoadingState) {
            return state.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text("Actualizar",
                    style: TextStyle(fontSize: 18, color: Colors.white));
          } else {
            return const Text(
              "Actualizar",
              style: TextStyle(fontSize: 18, color: Colors.white),
            );
          }
        })));
  }
}
