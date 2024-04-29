import 'dart:ffi';

import 'package:andromeda/screens/auth/Register/register_custom.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.type});
  final int type;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool typePassword = true;
  bool _isButtonDisabled = false;

  Future<void> getSesion() async {
    print('getSession');
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    if (sesion.isNotEmpty) {
      print('Sesion is alredy');
      Navigator.of(context).pushNamedAndRemoveUntil(
          sesion[0]['group_id'] == 5 ? 'home' : 'home-rest',
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getSesion();
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

    return Scaffold(
      backgroundColor: Background_Color,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipPath(
                child: Container(
                  height: 200,
                  color: const Color.fromARGB(255, 154, 126, 43),
                  child: Row(
                    children: const [
                      Text(
                        ' BIENVENIDOS A ANDROMEDA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(80),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    //color: Color.fromARGB(250, 242, 150, 5),
                    color: Color.fromARGB(255, 154, 126, 43),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: typePassword,
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
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          typePassword = !typePassword;
                        });
                      },
                      child: Icon(typePassword == true
                          ? Icons.lock_outline
                          : Icons.lock_open),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: baseButtom(
                    onPressed: _isButtonDisabled
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isButtonDisabled = !_isButtonDisabled;
                              });
                              try {
                                final login = await post(
                                    'admin',
                                    '',
                                    'integration/customer/token',
                                    {
                                      'username': _emailController.text,
                                      'password': _passwordController.text
                                    },
                                    '');

                                //Revision de respuesta
                                /*if (login == null) {
                            print('hay error: $login["message"]');
                            return;
                          }*/

                                print(login);

                                /*if (login["message"] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(login["message"])));
                            return;
                          }*/

                                //Creamos mapa para guardar en base de datos local
                                Map<String, dynamic> data = {
                                  'username': _emailController.text,
                                  'password': _passwordController.text,
                                  'token': login
                                };

                                //Vamos por la info del cliente
                                final customer =
                                    await get(login, 'custom', 'customers/me');

                                print('customer');
                                print(customer);

                                if (customer != null) {
                                  data['id'] = customer['id'];
                                  data['nombre'] = customer['firstname'];
                                  data['apellido_paterno'] =
                                      customer['lastname'];
                                  data['group_id'] = customer['group_id'];
                                }

                                print('data');
                                print(data);
                                print('token: $login');
                                //Obtenemos datos de la base local
                                final user = await serviceDB.instance
                                    .getById('users', 'id_user', 1);
                                //Si existen datos en base de datos local actualizamos datos en mapa
                                if (user.isNotEmpty) {
                                  await serviceDB.instance.updateRecord(
                                      'users', data, 'id_user', 1);
                                } else {
                                  //Si no existen datos en base de datos local insertamos datos en mapa
                                  data['id_user'] = 1;
                                  await serviceDB.instance
                                      .insertRecord('users', data);
                                }

                                //Redireccionamos a la pagina principal
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    data['group_id'] == 5
                                        ? 'home'
                                        : 'home-rest',
                                    (Route<dynamic> route) => false);
                              } catch (e) {
                                setState(() {
                                  _isButtonDisabled = !_isButtonDisabled;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              }
                            }
                          },
                    text: 'Iniciar Sesion'),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text("¿No tienes cuenta?"),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyRegisterPage(type: widget.type)),
                    );
                  },
                  child: const Text(
                    "Crear Cuenta",
                    style: TextStyle(
                        color: Color.fromARGB(255, 154, 126, 43),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamedAndRemoveUntil(
                    //    'register', (Route<dynamic> route) => false);
                    Navigator.pushNamed(context, 'RecoverPassword');
                  },
                  child: const Text(
                    "Olvidaste tu contraseña",
                    style: TextStyle(
                        color: Color.fromARGB(255, 154, 126, 43),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
