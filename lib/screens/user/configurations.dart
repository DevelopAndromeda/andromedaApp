import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/inicio/user/user_bloc.dart';
import 'package:andromeda/blocs/user/user_sesion_bloc.dart';

import 'package:andromeda/witgets/button_base.dart';
import 'package:andromeda/witgets/Colores_Base.dart';

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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _razonSocialController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _codigoPostalController = TextEditingController();
  String type = '';

  /*Future<void> getSesion() async {
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
  }*/

  final UserBloc _userBloc = UserBloc();

  @override
  void initState() {
    _userBloc.add(GetUser());
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
        backgroundColor: Colors.black, // Fondo negro
        centerTitle: true, // Centrar el título
        title: const Text(
          'Mi Cuenta',
          style: TextStyle(
            fontSize: 24, // Tamaño de fuente (puedes ajustarlo)
            color: Colors.white, // Texto blanco
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        leading: BackButton(
            onPressed: () => Navigator.pushNamed(context, 'profile')),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => _userBloc,
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                  ),
                );
              }
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return state.data['group_id'] == 5
                      ? _customer(state.data)
                      : _restaurant(state.data);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        /*child: Form(
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
                          suffixIcon:
                              const Icon(Icons.supervised_user_circle_outlined),
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
                          labelText: 'Apellido', // Cambiar label por labelText
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 106, 106)),
                          suffixIcon:
                              const Icon(Icons.supervised_user_circle_outlined),
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
                            width: 2.0, // Grosor del contorno al estar enfocado
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
              ]),
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

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Exito')));
                          setState(() {});
                        } catch (e) {
                          //print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                    text: const Text(
                      "Guardar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
              ),
            ],
          ),
        ),*/
      ),
    );
  }

  Widget _customer(data) {
    print(data);
    return Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          userInfo(data['nombre'], data['apellido_paterno']),
          mailInfo(data['username']),
          telefonoInfo(data['telefono']),
          ciudadInfo(data['name_city']),
          codigoPostalInfo(data['zip_code']),
          createButton(data['group_id'])
        ]));
  }

  Form _restaurant(data) {
    print(data);
    return Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          userInfo(data['nombre'], data['apellido_paterno']),
          mailInfo(data['username']),
          telefonoInfo(data['telefono']),
          rfcInfo(data['rfc_id']),
          razonSocialInfo(data['name_business']),
          ciudadInfo(data['name_city']),
          codigoPostalInfo(data['zip_code']),
          createButton(data['group_id'])
        ]));
  }

  Row userInfo(String value, String values) {
    _firstController.text = value;
    _lastController.text = values;
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
                suffixIcon: const Icon(Icons.supervised_user_circle_outlined),
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
                    width: 2.0, // Grosor del contorno al estar enfocado
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
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                labelText: 'Apellido', // Cambiar label por labelText
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
                suffixIcon: const Icon(Icons.supervised_user_circle_outlined),
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
                    width: 2.0, // Grosor del contorno al estar enfocado
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
    );
  }

  Row mailInfo(String value) {
    _mailController.text = value;
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            controller: _mailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color:
                      Color.fromARGB(255, 117, 117, 117), // Color del contorno
                  width: 1.0, // Grosor del contorno
                ),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: 'Correo', // Cambiar label por labelText
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
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
                  color: Color.fromARGB(
                      255, 36, 35, 35), // Color del contorno al estar enfocado
                  width: 2.0, // Grosor del contorno al estar enfocado
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
    ]);
  }

  Row telefonoInfo(String value) {
    _telephoneController.text = value;
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            controller: _telephoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color:
                      Color.fromARGB(255, 117, 117, 117), // Color del contorno
                  width: 1.0, // Grosor del contorno
                ),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: 'Telefono', // Cambiar label por labelText
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
              suffixIcon: const Icon(Icons.phone),
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
                  color: Color.fromARGB(
                      255, 36, 35, 35), // Color del contorno al estar enfocado
                  width: 2.0, // Grosor del contorno al estar enfocado
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu telefono';
              }

              return null;
            },
          ),
        ),
      ),
    ]);
  }

  Row rfcInfo(String value) {
    _rfcController.text = value;
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            controller: _rfcController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color:
                      Color.fromARGB(255, 117, 117, 117), // Color del contorno
                  width: 1.0, // Grosor del contorno
                ),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: 'RFC', // Cambiar label por labelText
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
              suffixIcon: const Icon(Icons.edit_document),
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
                  color: Color.fromARGB(
                      255, 36, 35, 35), // Color del contorno al estar enfocado
                  width: 2.0, // Grosor del contorno al estar enfocado
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu RFC';
              }

              return null;
            },
          ),
        ),
      ),
    ]);
  }

  Row razonSocialInfo(String value) {
    _razonSocialController.text = value;
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            controller: _razonSocialController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color:
                      Color.fromARGB(255, 117, 117, 117), // Color del contorno
                  width: 1.0, // Grosor del contorno
                ),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: 'Razon Social', // Cambiar label por labelText
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
              suffixIcon: const Icon(Icons.business_sharp),
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
                  color: Color.fromARGB(
                      255, 36, 35, 35), // Color del contorno al estar enfocado
                  width: 2.0, // Grosor del contorno al estar enfocado
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu Razon Social';
              }

              return null;
            },
          ),
        ),
      ),
    ]);
  }

  Row ciudadInfo(String value) {
    _ciudadController.text = value;
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            controller: _ciudadController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color:
                      Color.fromARGB(255, 117, 117, 117), // Color del contorno
                  width: 1.0, // Grosor del contorno
                ),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: 'Ciudad', // Cambiar label por labelText
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
              suffixIcon: const Icon(Icons.place),
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
                  color: Color.fromARGB(
                      255, 36, 35, 35), // Color del contorno al estar enfocado
                  width: 2.0, // Grosor del contorno al estar enfocado
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu Ciudad';
              }

              return null;
            },
          ),
        ),
      ),
    ]);
  }

  Row codigoPostalInfo(String value) {
    _codigoPostalController.text = value;
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            controller: _codigoPostalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(
                  color:
                      Color.fromARGB(255, 117, 117, 117), // Color del contorno
                  width: 1.0, // Grosor del contorno
                ),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: 'Codigo Postal', // Cambiar label por labelText
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
              suffixIcon: const Icon(Icons.post_add_outlined),
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
                  color: Color.fromARGB(
                      255, 36, 35, 35), // Color del contorno al estar enfocado
                  width: 2.0, // Grosor del contorno al estar enfocado
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu Codigo Postal';
              }

              return null;
            },
          ),
        ),
      ),
    ]);
  }

  Container createButton(int groupId) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: baseButtom(onPressed: () async {
          //print('aca');
          if (_formKey.currentState!.validate()) {
            try {
              Map<String, dynamic> data = {
                'email': _mailController.text,
                'firstname': _firstController.text,
                'lastname': _lastController.text,
              };

              data['zip_code'] = _codigoPostalController.text;
              data['name_city'] = _ciudadController.text;
              data['telefono'] = _telephoneController.text;
              if (groupId == 4) {
                data['rfc_id'] = _rfcController.text;
                data['name_business'] = _razonSocialController.text;
              }

              /*if (groupId == 5) {
                //data['gender'] = _generoController.text;
                data['zip_code'] = _codigoPostalController.text;
                data['name_city'] = _ciudadController.text;
                data['telefono'] = _telephoneController.text;
              } else {
                data['rfc_id'] = _rfcController.text;
                data['name_business'] = _razonSocialController.text;
              }*/
              context.read<UserSesionLogic>().updateUserLogic(data, context);
            } catch (E) {
              print(E);
            }
          }
        }, text: BlocBuilder<UserSesionLogic, UserSsionState>(
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
