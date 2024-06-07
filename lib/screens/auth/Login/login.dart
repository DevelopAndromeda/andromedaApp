import 'package:andromeda/screens/auth/Register/register_custom.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/Button_Base.dart';
import 'package:andromeda/Witgets/Colores_Base.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/utilities/constanst.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool typePassword = true;
  bool _isButtonDisabled = false;
  int selectedButton = 0;
  bool isClicked = false;
  bool isComensalSelected = false;
  bool isRestauranteSelected = false;
  int type = -1;

  Future<void> getSesion() async {
    //print('getSession');
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    if (sesion.isNotEmpty) {
      //print('Sesion is alredy');
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
    return Scaffold(
      backgroundColor: Background_Color,
      body: SingleChildScrollView(child: _createForm()),
    );
  }

  Form _createForm() {
    return Form(
      key: _formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipPath(
            child: Container(
              width: 450,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'assets/Login.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
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
          const Divider(
            height: 20, // Altura del separador
            color: Color.fromARGB(255, 255, 255, 255), // Color del separador
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
            height: 20, // Altura del separador
            color: Color.fromARGB(255, 255, 255, 255), // Color del separador
            thickness: 2, // Grosor del separador
            indent: 20, // Espaciado izquierdo del separador
            endIndent: 20, // Espaciado derecho del separador
          ),
          //Textfield Correo
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: TextFormField(
              controller: _emailController,
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
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
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
          //Textfield Contraseña
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: TextFormField(
              controller: _passwordController,
              obscureText: typePassword,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                enabledBorder: OutlineInputBorder(
                  // Borde cuando está habilitado
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Colors.black, // Color negro
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  // Borde cuando está enfocado
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Colors.black, // Color negro
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                labelText: 'Contraseña',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 129, 129, 129)),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      // Botón tipo icono para mostrar/ocultar contraseña
                      icon: Icon(typePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          typePassword = !typePassword;
                        });
                      },
                    ),
                  ],
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
            margin: const EdgeInsets.symmetric(horizontal: 58, vertical: 30),
            child: baseButtom(
                onPressed: _isButtonDisabled
                    ? () {}
                    : () async {
                        if (_formKeyLogin.currentState!.validate()) {
                          setState(() {
                            _isButtonDisabled = !_isButtonDisabled;
                          });
                          try {
                            final login = await post(
                                '',
                                'admin',
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
                              responseErrorWarning(context, login['message']);
                              setState(() {
                                _isButtonDisabled = !_isButtonDisabled;
                              });
                              return;
                            }

                            print(login);

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
                              data['apellido_paterno'] = customer['lastname'];
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
                              await serviceDB.instance
                                  .updateRecord('users', data, 'id_user', 1);
                            } else {
                              //Si no existen datos en base de datos local insertamos datos en mapa
                              data['id_user'] = 1;
                              await serviceDB.instance
                                  .insertRecord('users', data);
                            }

                            responseSuccessWarning(
                                context, 'Inicio de sesion Exitoso');

                            //Redireccionamos a la pagina principal
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                data['group_id'] == 5 ? 'home' : 'home-rest',
                                (Route<dynamic> route) => false);
                          } catch (e) {
                            setState(() {
                              _isButtonDisabled = !_isButtonDisabled;
                            });
                            //print(e);
                          }
                        }
                      },
                text: 'Iniciar Sesion'),
          ),
          SizedBox(
            width: 295, // Ancho deseado para el botón
            height: 39, // Alto deseado para el botón
            child: MaterialButton(
              onPressed: () {
                print(type);
                if (type == -1) {
                  responseWarning(context, 'Seleccione tipo de usuario');
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyRegisterPage(type: type),
                  ),
                );
              },
              color: const Color.fromARGB(
                  255, 85, 85, 85), // Color de fondo del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    4), // Ajusta el radio del borde a 0 para quitar el redondeo
              ),
              child: const Text(
                "Crear Cuenta",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Color del texto
                ),
              ),
            ),
          ),
          const Divider(
            height: 30, // Altura del separador
            color: Color.fromARGB(255, 255, 255, 255), // Color del separador
            thickness: 2, // Grosor del separador
            indent: 20, // Espaciado izquierdo del separador
            endIndent: 20, // Espaciado derecho del separador
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
                //Navigator.of(context).pushNamedAndRemoveUntil(
                //    'register', (Route<dynamic> route) => false);
                Navigator.pushNamed(context, 'RecoverPassword');
              },
              child: const Text(
                "Olvidaste tu contraseña",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150, // Ancho del primer Boton
                  height: 50, // Alto del primer boton
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type = 0;
                      });
                      //print('tipo -> ${type}');
                      /*setState(() {
                            isComensalSelected = true;
                            isRestauranteSelected = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyLoginPage()),
                          );*/
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation:
                          0, // Establece la elevación a 0 para que no haya sombra
                    ),
                    child: Text(
                      'Comensal',
                      style: TextStyle(
                          color: type == 0
                              ? Color.fromARGB(255, 0, 0, 0)
                              : Color.fromARGB(78, 61, 61, 61)),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Espacio entre botones
                SizedBox(
                  width: 150, // Ancho del segundo boton
                  height: 50, // Alto del segundo boton
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type = 1;
                      });
                      //print('tipo -> ${type}');
                      /*setState(() {
                            isComensalSelected = false;
                            isRestauranteSelected = true;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyLoginPage()),
                          );*/
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation:
                          0, // Establece la elevación a 0 para que no haya sombra
                    ),
                    child: Text(
                      'Restaurante',
                      style: TextStyle(
                          color: type == 1
                              ? Color.fromARGB(255, 0, 0, 0)
                              : Color.fromARGB(78, 61, 61, 61)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
