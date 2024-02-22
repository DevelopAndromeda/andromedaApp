import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/Witgets/General/Textfield_Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:andromeda/screens/auth%20costum/Register/registro_viewmodel.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

class RegisterContent extends StatefulWidget {
  const RegisterContent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyRegisterContet createState() => _MyRegisterContet();
}

class _MyRegisterContet extends State<RegisterContent> {
  //RegisterViewModel vm;
  //RegisterContent(this.vm);
  var firstname;
  var lastname;
  var email;
  var password;

  String? selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              //Decoracion dorada de fondo
              height: MediaQuery.of(context).size.height * 0.27,
              alignment: Alignment.center,
              color: Base_ColorDorado,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    //Titulo de fondo
                    'ANDROMEDA',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: const [
              Text(
                'Crea tu cuenta',
                style: TextStyle(color: Base_ColorDorado, fontSize: 25),
              ),
              Text(
                'Registro',
                style: TextStyle(color: Base_ColorDorado, fontSize: 25),
              ),
            ],
          ),
          const SizedBox(height: 50), //Espacio separador
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Tipo',
                    hintText: 'Seleccione Tipo'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Tipo';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: baseTextfield(
                label: 'Nombre',
                icon: Icons.person_2_outlined,
                //error: vm.state.username.error,
                onChanged: (value) {
                  setState(() {
                    firstname = value;
                  });
                  //vm.changeUsername(value);
                }),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: baseTextfield(
                label: 'Apellido',
                icon: Icons.person_2_outlined,
                //error: vm.state.username.error,
                onChanged: (value) {
                  //vm.changeUsername(value);
                  setState(() {
                    lastname = value;
                  });
                }),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: baseTextfield(
                label: 'Correo',
                icon: Icons.email_outlined,
                //error: vm.state.email.error,
                onChanged: (value) {
                  //vm.changeEmail(value);
                  setState(() {
                    email = value;
                  });
                }),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: baseTextfield(
                label: 'Contraseña',
                icon: Icons.lock_outline,
                obscureText: true,
                //error: vm.state.password.error,
                onChanged: (value) {
                  //vm.changePassword(value);
                }),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: baseTextfield(
                label: 'Confirmar contraseña',
                icon: Icons.lock_outline,
                obscureText: true,
                //error: vm.state.confirmPassword.error,
                onChanged: (value) {
                  //vm.changeconfirmPassword(value);
                  setState(() {
                    password = value;
                  });
                }),
          ),
          const SizedBox(height: 10),
          Container(
            // width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: baseButtom(
                text: 'Registrarse',
                onPressed: () async {
                  //Llamada a endpoint
                  final registro = await post('', '', 'customers', {
                    'customer': {
                      'email': email,
                      'firstname': firstname,
                      'lastname': lastname
                    },
                    'password': password
                  });

                  //Revision de respuesta
                  if (registro == null) {
                    print('ocurrio un error al registrar datos');
                    return;
                  }

                  //Creamos mapa para guardar en base de datos local
                  Map<String, dynamic> data = {
                    'id_user': 1,
                    'id': registro['id'],
                    'nombre': firstname,
                    'apellido_paterno': lastname,
                    'username': email,
                    'password': password,
                  };

                  final login = await post('', '', 'integration/customer/token',
                      {'username': email, 'password': password});

                  //Revision de respuesta
                  if (login == null) {
                    print('ocurrio un error al inicio de sesion');
                    return;
                  }

                  data['token'] = login;

                  await serviceDB.instance.insertRecord('users', data);

                  //vm.register();
                  Navigator.of(context).pushNamed('home');
                }),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Comensal", child: Text("Comensal")),
      const DropdownMenuItem(value: "Restaurante", child: Text("Restaurante")),
    ];
    return menuItems;
  }
}
