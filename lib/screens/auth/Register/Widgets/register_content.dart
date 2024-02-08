
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/Witgets/General/Textfield_Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:andromeda/screens/auth/Register/registro_viewmodel.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';


class RegisterContent extends StatelessWidget {
RegisterViewModel vm;
RegisterContent (this.vm);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(//Decoracion dorada de fondo
            height: MediaQuery.of(context).size.height * 0.27,
            alignment: Alignment.center,
            color: Base_ColorDorado,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(//Titulo de fondo
                  'ANDROMEDA',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                  ),)],
            ),
          ),
        ),
//Parte inferior del encabezado de Andromeda

        const Column(
          children: [
                  Text ('Crea tu cuenta',
                    style: TextStyle(
                    color: Base_ColorDorado,
                    fontSize: 25),
                    ),
                  Text('Registro',
                    style: TextStyle(
                    color: Base_ColorDorado,
                    fontSize: 25),
                    ),
                  ],
              ),
              
              const SizedBox(height: 50),//Espacio separador
              
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: baseTextfield(
                 label: 'Nombre de usuario', 
                 icon: Icons.person_2_outlined, 
                 error: vm.state.username.error,
                 onChanged: (value){
                      vm.changeUsername(value);
                    }
                  ),
                ),  
            const SizedBox(height: 20),

               Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                  child: baseTextfield(
                  label: 'Correo', 
                  icon: Icons.email_outlined, 
                  error: vm.state.email.error,
                  onChanged: (value){
                      vm.changeEmail(value);
                    }
                  ),
                ), 
            const SizedBox(height: 20),
               Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: baseTextfield(
                label: 'Contraseña', 
                icon: Icons.lock_outline,
                obscureText: true,
                error: vm.state.password.error, 
                onChanged: (value){
                    vm.changePassword(value);
                    }
                  ),
               ), 
            const SizedBox(height: 20),

               Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: baseTextfield(
                label: 'Confirmar contraseña', 
                icon: Icons.lock_outline, 
                obscureText: true,
                error: vm.state.confirmPassword.error,
                onChanged: (value){
                  vm.changeconfirmPassword(value);
                    }
                  ),
               ), 

          const SizedBox(height: 20),
            Container(
             // width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: baseButtom(
                text: 'Registrarse', 
                onPressed: (){
                    vm.register();
                }),
            ),
            
            ],
    );
  }
}