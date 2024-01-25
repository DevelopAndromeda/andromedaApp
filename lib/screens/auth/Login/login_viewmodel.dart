import 'package:flutter/material.dart';
import 'package:andromeda/Util/validation_item.dart';
import 'package:andromeda/screens/auth/Login/login_state.dart';

class LoginViewModel extends ChangeNotifier{
  LoginState _state = LoginState();

  //Getters 

  LoginState get state => _state;


  //Setters 


  void changeEmail(String value){

    final bool emailFormatValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(value);
      //Formato de validaciones de email
    if(!emailFormatValid){
      _state = _state.copywith(email: ValidationItem(error: 'No es un email'));
    }
    else if (value.length >= 6){
      _state = _state.copywith(email: ValidationItem(value: value, error: ''));
    notifyListeners();
    }else{
      _state = _state.copywith(email: ValidationItem(error: 'Al menos 6 caracteres minimos'));
    }

    notifyListeners();
    
  }

   void changePassword(String value){
    if (value.length >= 6){
      _state = _state.copywith(password: ValidationItem(value: value, error: ''));
    notifyListeners();
    }else{
      _state = _state.copywith(password: ValidationItem(error: 'Al menos 6 caracteres minimos'));
    notifyListeners();
    }
    
  }

  void login(){
    if(state.isValid()){
    print ('Email: ${_state.email.value}');
    print ('Password: ${_state.password.value}');
    }
   else{
    print('El formulario no es valido');
   }
  }
}