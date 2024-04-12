import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key, required this.type});
  final int type;

  @override
  _MyRegisterContet createState() => _MyRegisterContet();
}

class _MyRegisterContet extends State<MyRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  List<String> dropdownItems = <String>[];

  /*List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: widget.type == 0 ? "Comensal" : "Restaurante", child: Text("Comensal"))
    ];
    return menuItems;
  }*/

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    dropdownItems.add(widget.type == 0 ? "Comensal" : "Restaurante");
  }

  @override
  Widget build(BuildContext context) {
    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      return value!.isEmpty || !regex.hasMatch(value)
          ? 'Ingresa un correo valido'
          : null;
    }

    String? validatePasswords() {
      return _passwordController.text != _confirmPasswordController.text
          ? 'Las contraseñas no coinciden'
          : null;
    }

    return Scaffold(
      backgroundColor: Base_ColorClaro,
      appBar: AppBar(
        title: Text(widget.type == 0 ? 'Comensal' : 'Restaurant'),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
              const SizedBox(height: 50),
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
                  items: dropdownItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                //items: dropdownItems),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _firstController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 249, 235, 208),
                      label: Text(
                        'Nombre',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: Icon(Icons.person_2_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu nombre';
                      }

                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _lastController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 249, 235, 208),
                      label: Text(
                        'Apellido',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: Icon(Icons.person_2_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu apellido';
                      }

                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 249, 235, 208),
                      label: Text(
                        'Correo',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo';
                      }

                      String? isValid = validateEmail(value);
                      if (isValid != null) {
                        return isValid;
                      }

                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 249, 235, 208),
                    label: Text(
                      'Contraseña',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    suffixIcon: Icon(Icons.lock_clock_outlined),
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
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 249, 235, 208),
                    label: Text(
                      'Confirmar contraseña',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    suffixIcon: Icon(Icons.lock_outline),
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
              ),
              const SizedBox(height: 10),
              Container(
                // width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: baseButtom(
                  text: 'Registrarse',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        //Llamada a endpoint
                        final registro = await post('', 'admin', 'customers', {
                          'customer': {
                            'email': _emailController.text,
                            'firstname': _firstController.text,
                            'lastname': _lastController.text,
                            "group_id": widget.type == 0 ? 5 : 4,
                          },
                          'password': _passwordController.text
                        });

                        print('registro');
                        print(registro);

                        if (registro["message"] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(registro["message"])));
                          return;
                        }

                        //Creamos mapa para guardar en base de datos local
                        Map<String, dynamic> data = {
                          'id_user': 1,
                          'id': registro['id'],
                          'nombre': _firstController.text,
                          'apellido_paterno': _lastController.text,
                          'username': _emailController.text,
                          'password': _passwordController.text,
                          'group_id': registro['group_id']
                        };

                        print(data);
                        print('data');

                        final login = await post(
                            '', '', 'integration/customer/token', {
                          'username': _emailController.text,
                          'password': _passwordController.text
                        });

                        print(login);
                        data['token'] = login;
                        print('token');

                        if (widget.type == 1 && registro['group_id'] == 5) {
                          final update = await put(
                              login, 'custom', 'customergroup/', {}, '4');

                          print(update);

                          if (update != null) {
                            data['group_id'] = update['data']['new_group_id'];
                          }
                        }

                        final user = await serviceDB.instance
                            .getById('users', 'id_user', 1);
                        print('usuario');
                        print(user);
                        //Si existen datos en base de datos local actualizamos datos en mapa
                        if (user.isNotEmpty) {
                          await serviceDB.instance
                              .updateRecord('users', data, 'id_user', 1);
                        } else {
                          //Si no existen datos en base de datos local insertamos datos en mapa
                          data['id_user'] = 1;
                          await serviceDB.instance.insertRecord('users', data);
                        }

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            widget.type == 0 ? 'home' : 'home-rest',
                            (Route<dynamic> route) => false);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
