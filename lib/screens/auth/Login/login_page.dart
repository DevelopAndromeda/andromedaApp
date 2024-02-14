import 'package:andromeda/screens/auth/Login/login_viewmodel.dart';
import 'package:andromeda/Witgets/General/Button_Base.dart';
import 'Widgets/login_content.dart';
import 'package:andromeda/Witgets/General/Textfield_Base.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'package:andromeda/services/db.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
//class LoginPage extends StatelessWidget {

  Future<void> getSesion() async {
    var sesion = await serviceDB.instance.getById('users', 'id_user', 1);
    if (sesion.isNotEmpty) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getSesion();
  }

  @override
  Widget build(BuildContext context) {
    //LoginViewModel vm = Provider.of<LoginViewModel>(context);
    return const Scaffold(
      backgroundColor: Background_Color,
      //body: loginContent(vm),
      body: loginContent(),
    );
  }
}
