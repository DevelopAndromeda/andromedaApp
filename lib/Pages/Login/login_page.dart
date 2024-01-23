import 'package:andromeda/Pages/Login/login_viewmodel.dart';
import 'package:andromeda/Witgets/Button_Base.dart';
import 'Widgets/login_content.dart';
import 'package:andromeda/Witgets/Textfield_Base.dart';
import 'package:andromeda/Witgets/Colores_Base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    
 LoginViewModel vm = Provider.of<LoginViewModel>(context);


    return  Scaffold(
      backgroundColor: Background_Color,
        body: loginContent(vm),
    );
  }
}