import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andromeda/Witgets/General/Colores_Base.dart';
import 'Widgets/register_content.dart';
import 'package:andromeda/screens/auth%20costum/Register/registro_viewmodel.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RegisterViewModel vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: Base_ColorClaro,
      body: RegisterContent(),
      //body: RegisterContent(vm),
    );
  }
}
