import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/Button_Base.dart';
import 'package:andromeda/Witgets/Colores_Base.dart';
import 'package:andromeda/Witgets/Textfield_Base.dart';
import 'package:andromeda/Pages/Login/login_viewmodel.dart';
//import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';




class loginContent extends StatelessWidget {
  
  LoginViewModel vm;
  loginContent(this.vm);

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              ClipPath(
                 // clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 200,
                    color: Color.fromARGB(255, 154, 126, 43),
                    child: Row(
                      children: [
                        Text(
                        ' BIENVENIDOS A ANDROMEDA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                  
                  ),
                  Container(
                    margin: EdgeInsets.all(80),
                    child: Text('Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      //color: Color.fromARGB(250, 242, 150, 5),
                      color: Color.fromARGB(255, 154, 126, 43),
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: baseTextfield(
                      onChanged:(value){
                        vm.changeEmail(value);
                      },
                      error: vm.state.email.error,
                      label: "Correo", icon: Icons.email_outlined)
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: baseTextfield(
                      onChanged:(value){
                        vm.changePassword(value);
                      }, 
                      error: vm.state.password.error,
                      label: "Contraseña", icon: Icons.lock_clock_outlined,obscureText: true, )
                  ),
                
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: baseButtom(
                    onPressed:(){//validacion del usuario y password
                    vm.login();
                    },
                    text: 'Iniciar Sesion'
                  )
                ),
                Spacer(),//Espacios de linea de codigo
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text("¿No tienes cuenta?")),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, 'register');
                    },
                    child: Text("Crear Cuenta",
                    style: TextStyle(
                      color: Color.fromARGB(255, 154, 126, 43),
                      fontWeight: FontWeight.bold
                    ),),
                  )),

              
          ],
        );
  }
}