import 'package:flutter/material.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/Witgets/General/Button_Base.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';

import 'package:andromeda/utilities/constanst.dart';

class MyConfigProfilePage extends StatefulWidget {
  const MyConfigProfilePage({super.key});

  @override
  State<MyConfigProfilePage> createState() => _MyConfigProfilePageState();
}

class _MyConfigProfilePageState extends State<MyConfigProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  /*final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool typePassword = true;
  bool typePasswordConfirm = true;*/
  String token = '';

  Future<void> getSesion() async {
    //print('getSession');
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    if (sesion.isNotEmpty) {
      //print('Sesion is alredy');
      //print(sesion);
      _firstController.text = sesion[0]['nombre'];
      _lastController.text = sesion[0]['apellido_paterno'];
      _mailController.text = sesion[0]['username'];
      //_phoneController.text = sesion[0]['telefono'] ?? '';
      token = sesion[0]['token'];
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSesion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: const Text('Modificacion de Perfil'),
        centerTitle: true,
        leading: const BackButton(),
        elevation: 1,
        backgroundColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          controller: _firstController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(
                                    255, 117, 117, 117), // Color del contorno
                                width: 1.0, // Grosor del contorno
                              ),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            labelText: 'Nombre', // Cambiar label por labelText
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 107, 106, 106)),
                            suffixIcon: const Icon(
                                Icons.supervised_user_circle_outlined),
                            enabledBorder: OutlineInputBorder(
                              // Estilo de contorno cuando está habilitado
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                color: Colors.grey, // Color del contorno
                                width: 2.0, // Grosor del contorno
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // Estilo de contorno cuando está enfocado
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 36, 35,
                                    35), // Color del contorno al estar enfocado
                                width:
                                    2.0, // Grosor del contorno al estar enfocado
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu Nombre';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          controller: _lastController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(
                                    255, 117, 117, 117), // Color del contorno
                                width: 1.0, // Grosor del contorno
                              ),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            labelText:
                                'Apellido', // Cambiar label por labelText
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 107, 106, 106)),
                            suffixIcon: const Icon(
                                Icons.supervised_user_circle_outlined),
                            enabledBorder: OutlineInputBorder(
                              // Estilo de contorno cuando está habilitado
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                color: Colors.grey, // Color del contorno
                                width: 2.0, // Grosor del contorno
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // Estilo de contorno cuando está enfocado
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 36, 35,
                                    35), // Color del contorno al estar enfocado
                                width:
                                    2.0, // Grosor del contorno al estar enfocado
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu Apellido';
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextFormField(
                        controller: _mailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(
                                  255, 117, 117, 117), // Color del contorno
                              width: 1.0, // Grosor del contorno
                            ),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          labelText: 'Correo', // Cambiar label por labelText
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 106, 106)),
                          suffixIcon: const Icon(Icons.email_outlined),
                          enabledBorder: OutlineInputBorder(
                            // Estilo de contorno cuando está habilitado
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Colors.grey, // Color del contorno
                              width: 2.0, // Grosor del contorno
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // Estilo de contorno cuando está enfocado
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 36, 35,
                                  35), // Color del contorno al estar enfocado
                              width:
                                  2.0, // Grosor del contorno al estar enfocado
                            ),
                          ),
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
                        },
                      ),
                    ),
                  ),
                  /*Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(
                              255, 117, 117, 117), // Color del contorno
                          width: 1.0, // Grosor del contorno
                        ),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      labelText: 'Telefono', // Cambiar label por labelText
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
                      suffixIcon: Icon(Icons.phone),
                      enabledBorder: OutlineInputBorder(
                        // Estilo de contorno cuando está habilitado
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.grey, // Color del contorno
                          width: 2.0, // Grosor del contorno
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Estilo de contorno cuando está enfocado
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 36, 35,
                              35), // Color del contorno al estar enfocado
                          width: 2.0, // Grosor del contorno al estar enfocado
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu Telefono';
                      }

                      return null;
                    },
                  ),
                ),
              )*/
                ]),
                /*Row(children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: typePassword,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(
                              255, 117, 117, 117), // Color del contorno
                          width: 1.0, // Grosor del contorno
                        ),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      labelText: 'Contraseña', // Cambiar label por labelText
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            typePassword = !typePassword;
                          });
                        },
                        child: Icon(typePassword == true
                            ? Icons.lock_clock_outlined
                            : Icons.lock_open_sharp),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // Estilo de contorno cuando está habilitado
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.grey, // Color del contorno
                          width: 2.0, // Grosor del contorno
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Estilo de contorno cuando está enfocado
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 36, 35,
                              35), // Color del contorno al estar enfocado
                          width: 2.0, // Grosor del contorno al estar enfocado
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo';
                      }

                      String? isValid = validatePasswords();
                      if (isValid != null) {
                        return isValid;
                      }

                      return null;
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: typePasswordConfirm,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(
                              255, 117, 117, 117), // Color del contorno
                          width: 1.0, // Grosor del contorno
                        ),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      labelText:
                          'Confirmar contraseña', // Cambiar label por labelText
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
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
                        // Estilo de contorno cuando está habilitado
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: Colors.grey, // Color del contorno
                          width: 2.0, // Grosor del contorno
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Estilo de contorno cuando está enfocado
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 36, 35,
                              35), // Color del contorno al estar enfocado
                          width: 2.0, // Grosor del contorno al estar enfocado
                        ),
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
                ),
              )
            ]),*/
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: baseButtom(
                      onPressed: () async {
                        //print('aca');
                        if (_formKey.currentState!.validate()) {
                          try {
                            final customer = await put(
                                token,
                                'custom',
                                'customers/me',
                                {
                                  'customer': {
                                    'email': _mailController.text,
                                    'firstname': _firstController.text,
                                    'lastname': _lastController.text,
                                  },
                                },
                                '');
                            if (customer.isNotEmpty) {
                              Map<String, dynamic> data = {
                                'nombre': customer['firstname'],
                                'apellido_paterno': customer['lastname'],
                                'username': customer['email']
                              };

                              await serviceDB.instance
                                  .updateRecord('users', data, 'id_user', 1);
                            }

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Exito')));
                            setState(() {});
                          } catch (e) {
                            //print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                      text: 'Guardar'),
                ),
              ],
            )),
      ),
    );
  }
}
