import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/utilities/constanst.dart';

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
  bool typePassword = true;
  bool typePasswordConfirm = true;
  bool _isButtonDisabled = false;
  String selectedGender = '';

  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }
  //List<String> dropdownItems = <String>[];

  /*List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: widget.type == 0 ? "Comensal" : "Restaurante", child: Text("Comensal"))
    ];
    return menuItems;
  }*/

  //String? selectedValue;

  @override
  void initState() {
    super.initState();
    //dropdownItems.add(widget.type == 0 ? "Comensal" : "Restaurante");
  }

  @override
  Widget build(BuildContext context) {
    String? validatePasswords() {
      return _passwordController.text != _confirmPasswordController.text
          ? 'Las contraseñas no coinciden'
          : null;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          widget.type == 0 ? 'Comensal' : 'Restaurantero',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ClipPath(
                child: Container(
                  width: 450,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    'assets/Login.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 10,
                right: 0,
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    'Recomendacion del mes, Black food - Roma CDMX                         ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 20, // Altura del separador
                color:
                    Color.fromARGB(255, 255, 255, 255), // Color del separador
                thickness: 2, // Grosor del separador
                indent: 20, // Espaciado izquierdo del separador
                endIndent: 20, // Espaciado derecho del separador
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  'assets/LogoWhite.png',
                  fit: BoxFit.cover,
                ),
              ),
              const Divider(
                height: 1, // Altura del separador
                color:
                    Color.fromARGB(255, 255, 255, 255), // Color del separador
                thickness: 2, // Grosor del separador
                indent: 20, // Espaciado izquierdo del separador
                endIndent: 20, // Espaciado derecho del separador
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _firstController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      label: const Text(
                        'Nombre',
                        style: TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: const Icon(Icons.person_2_outlined),
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
                          borderRadius: BorderRadius.circular(4.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      label: const Text(
                        'Apellido',
                        style: TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: const Icon(Icons.person_2_outlined),
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      label: const Text(
                        'Correo',
                        style: TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: const Icon(Icons.email_outlined),
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
                  obscureText: typePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    label: const Text(
                      'Contraseña',
                      style: TextStyle(color: Colors.grey),
                    ),
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
                  obscureText: typePasswordConfirm,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Seleccione su género:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () => selectGender('Masculino'),
                          icon: Icon(
                            Icons.male,
                            color: selectedGender == 'Masculino'
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          label: Text(
                            'Masculino',
                            style: TextStyle(
                              color: selectedGender == 'Femenino'
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedGender == 'Masculino'
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            shadowColor: Colors.blue,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => selectGender('Femenino'),
                          icon: Icon(
                            Icons.female,
                            color: selectedGender == 'Femenino'
                                ? Colors.pink
                                : Colors.grey,
                          ),
                          label: Text(
                            'Femenino',
                            style: TextStyle(
                              color: selectedGender == 'Femenino'
                                  ? Colors.pink
                                  : Colors.grey,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedGender == 'female'
                                ? Colors.pink.shade100
                                : Colors.grey.shade200,
                            shadowColor: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Género seleccionado: $selectedGender',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                // width: double.maxFinite,
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: baseButtom(
                  text: 'Registrarse',
                  onPressed: _isButtonDisabled
                      ? () {}
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              //Llamada a endpoint
                              final registro = await post(
                                  '',
                                  'admin',
                                  'customers',
                                  {
                                    'customer': {
                                      'email': _emailController.text,
                                      'firstname': _firstController.text,
                                      'lastname': _lastController.text,
                                      "group_id": widget.type == 0 ? 5 : 4,
                                    },
                                    'password': _passwordController.text
                                  },
                                  '');

                              //print('registro');

                              if (registro == null) {
                                //print('hay error');
                                //print(registro);
                                //ScaffoldMessenger.of(context).showSnackBar(
                                //    SnackBar(
                                //        content: Text(registro['message'])));
                                setState(() {
                                  _isButtonDisabled = !_isButtonDisabled;
                                });
                                return;
                              }

                              /*if (registro["message"] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(registro["message"])));
                          return;
                        }*/

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

                              //print(data);
                              //print('data');

                              final login = await post(
                                  '',
                                  '',
                                  'integration/customer/token',
                                  {
                                    'username': _emailController.text,
                                    'password': _passwordController.text
                                  },
                                  '');

                              //Revision de respuesta
                              if (login.runtimeType != String) {
                                //print('hay error');
                                //print(login['message']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(login['message'])));
                                setState(() {
                                  _isButtonDisabled = !_isButtonDisabled;
                                });
                                return;
                              }

                              //print(login);

                              if (widget.type == 1 &&
                                  registro['group_id'] == 5) {
                                final update = await put(
                                    login, 'custom', 'customergroup/', {}, '4');

                                //print(update);

                                if (update != null) {
                                  data['group_id'] =
                                      update['data']['new_group_id'];
                                }
                              }

                              final user = await serviceDB.instance
                                  .getById('users', 'id_user', 1);
                              //print('usuario');
                              //print(user);
                              //Si existen datos en base de datos local actualizamos datos en mapa
                              if (user.isNotEmpty) {
                                await serviceDB.instance
                                    .updateRecord('users', data, 'id_user', 1);
                              } else {
                                //Si no existen datos en base de datos local insertamos datos en mapa
                                data['id_user'] = 1;
                                await serviceDB.instance
                                    .insertRecord('users', data);
                              }

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  widget.type == 0 ? 'home' : 'home-rest',
                                  (Route<dynamic> route) => false);
                            } catch (e) {
                              setState(() {
                                _isButtonDisabled = !_isButtonDisabled;
                              });
                              //print(e);
                            }
                          }
                        },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
