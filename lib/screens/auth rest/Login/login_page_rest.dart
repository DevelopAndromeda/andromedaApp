import 'package:andromeda/screens/auth%20costum/Login/login_viewmodel.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';
import 'package:andromeda/Witgets/General/Textfield_Base.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/services/db.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class LoginPageRest extends StatefulWidget {
  const LoginPageRest({super.key});

  @override
  State<LoginPageRest> createState() => _LoginPageRestState();
}

class _LoginPageRestState extends State<LoginPageRest> {

  Future<void> getSesion() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    if (sesion.isNotEmpty) {
      Navigator.of(context).pushNamed('home');
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
      //body: loginContent(vm),
      body: LoginPageRest(),

    );
  }
}
