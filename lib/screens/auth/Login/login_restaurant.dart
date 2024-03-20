import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';
import 'package:andromeda/Witgets/General/Textfield_Base.dart';
//import 'package:andromeda/screens/auth_costum/Login/login_viewmodel.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

class MyLoginPageRestaurant extends StatefulWidget {
  const MyLoginPageRestaurant({super.key});

  @override
  State<MyLoginPageRestaurant> createState() => _MyLoginPageRestaurant();
}

class _MyLoginPageRestaurant extends State<MyLoginPageRestaurant> {
  var username;
  var password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: baseTextfield(
                  onChanged: (value) {
                    //vm.changeEmail(value);
                    setState(() {
                      username = value;
                    });
                  },
                  //error: vm.state.email.error,
                  label: "Correo",
                  icon: Icons.email_outlined),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: baseTextfield(
                onChanged: (value) {
                  //vm.changePassword(value);
                  setState(() {
                    password = value;
                  });
                },
                //error: vm.state.password.error,
                label: "Contraseña",
                icon: Icons.lock_clock_outlined,
                obscureText: true,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: baseButtom(
                  onPressed: () async {
                    //validacion del usuario y password
                    //vm.login();
                    //Llamada a endpoint
                    final login = await post(
                        '',
                        '',
                        'integration/customer/token',
                        {'username': username, 'password': password});

                    //Revision de respuesta
                    if (login == null) {
                      print('hay error: $login["message"]');
                      return;
                    }

                    //Creamos mapa para guardar en base de datos local
                    Map<String, dynamic> data = {
                      'username': username,
                      'password': password,
                      'token': login
                    };

                    //Vamos por la info del cliente
                    final customer = await get(login, 'custom', 'customers/me');

                    if (customer != null) {
                      data['id'] = customer['id'];
                      data['nombre'] = customer['firstname'];
                      data['apellido_paterno'] = customer['lastname'];
                    }

                    print('token: $login');
                    //Obtenemos datos de la base local
                    final user =
                        await serviceDB.instance.getById('users', 'id_user', 1);
                    //Si existen datos en base de datos local actualizamos datos en mapa
                    if (user.isNotEmpty) {
                      await serviceDB.instance
                          .updateRecord('users', data, 'id_user', 1);
                    } else {
                      //Si no existen datos en base de datos local insertamos datos en mapa
                      data['id_user'] = 1;
                      await serviceDB.instance.insertRecord('users', data);
                    }

                    //Redireccionamos a la pagina principal
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'home-rest', (Route<dynamic> route) => false);
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
                  Navigator.pushNamed(context, 'register-rest');
                },
                child: const Text(
                  "Crear Cuenta",
                  style: TextStyle(
                      color: Color.fromARGB(255, 154, 126, 43),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
