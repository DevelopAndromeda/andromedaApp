import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/login/login_bloc.dart';

import 'package:andromeda/witgets/button_base.dart';
import 'package:andromeda/witgets/colores_base.dart';

import 'package:andromeda/screens/auth/register.dart';
import 'package:andromeda/screens/auth/recover_password.dart';

import 'package:andromeda/utilities/constanst.dart';
import 'package:andromeda/utilities/strings.dart';

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
  int type = -1;

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
      body: SingleChildScrollView(child: _createForm()),
    );
  }

  var clip = ClipPath(
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
  );

  var recomendacion = Container(
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
  );

  var divisor = const Divider(
    height: 20, // Altura del separador
    color: Color.fromARGB(255, 255, 255, 255), // Color del separador
    thickness: 2, // Grosor del separador
    indent: 20, // Espaciado izquierdo del separador
    endIndent: 20, // Espaciado derecho del separador
  );

  var logo = Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10)),
    child: Image.asset(
      'assets/LogoWhite.png',
      fit: BoxFit.cover,
    ),
  );

  Container emailInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: TextFormField(
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
    );
  }

  Container passwInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        obscureText: typePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 117, 117, 117), // Color del contorno
              width: 1.0, // Grosor del contorno
            ),
          ),
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
                icon: Icon(
                    typePassword ? Icons.visibility_off : Icons.visibility),
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
    );
  }

  Container buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 58, vertical: 30),
      child: baseButtom(onPressed: () async {
        if (_formKeyLogin.currentState!.validate()) {
          context.read<AuthLogic>().loginLogic(
              _emailController.text, _passwordController.text, context);
        } else {
          responseErrorWarning(context, MyString.required);
          return;
        }
      }, text: BlocBuilder<AuthLogic, AuthState>(builder: (context, state) {
        if (state is LoginLoadingState) {
          return state.isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text("Iniciar Sesion",
                  style: TextStyle(fontSize: 18, color: Colors.white));
        } else {
          return const Text(
            "Iniciar Sesion",
            style: TextStyle(fontSize: 18, color: Colors.white),
          );
        }
      })),
    );
  }

  SizedBox buttonRegister() {
    return SizedBox(
      width: 295, // Ancho deseado para el botón
      height: 39, // Alto deseado para el botón
      child: MaterialButton(
        onPressed: () {
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
        color:
            const Color.fromARGB(255, 85, 85, 85), // Color de fondo del botón
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
    );
  }

  var textCuenta = Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(bottom: 15),
    child: const Text("¿No tienes cuenta?"),
  );

  Container forget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyRecoverPassword(),
            ),
          );
        },
        child: const Text(
          "Olvidaste tu contraseña",
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  SizedBox typeButton() {
    return SizedBox(
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
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(78, 61, 61, 61)),
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
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(78, 61, 61, 61)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form _createForm() {
    return Form(
      key: _formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          clip,
          recomendacion,
          divisor,
          logo,
          divisor,
          emailInput(),
          passwInput(),
          buttonLogin(),
          textCuenta,
          buttonRegister(),
          divisor,
          forget(),
          typeButton()
        ],
      ),
    );
  }
}
