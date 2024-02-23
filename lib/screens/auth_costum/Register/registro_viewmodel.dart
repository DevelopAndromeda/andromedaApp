import 'package:flutter/material.dart';
import 'package:andromeda/utilities/validation_item.dart';
import 'package:andromeda/screens/auth_costum/Register/registro_state.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterState _state = RegisterState();

  RegisterState get state => _state;

  register() {
    if (_state.isValid()) {
      print('Email del formulario ${_state.email.value}');
      print('Username del formulario ${_state.username.value}');
      print('Contraseña del formulario ${_state.password.value}');
      print('C Contraseña del formulario ${_state.confirmPassword.value}');
    } else {
      print('Formulario no valido');
    }
  }

  changeEmail(String value) {
    final bool emailFormatValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    //Formato de validaciones de email
    if (!emailFormatValid) {
      _state = _state.copyWith(email: ValidationItem(error: 'No es un email'));
    } else if (value.length >= 3) {
      _state = _state.copyWith(email: ValidationItem(value: value, error: ''));
    } else {
      _state = _state.copyWith(
          email: ValidationItem(error: 'Al menos 6 caracteres'));
    }
    notifyListeners();
  }

  changeUsername(String value) {
    if (value.length >= 5) {
      _state =
          _state.copyWith(username: ValidationItem(value: value, error: ''));
    } else {
      _state = _state.copyWith(
          username: ValidationItem(error: 'Al menos 8 caracteres'));
    }
    notifyListeners();
  }

  changePassword(String value) {
    if (value.length >= 5) {
      _state =
          _state.copyWith(password: ValidationItem(value: value, error: ''));
    } else {
      _state = _state.copyWith(
          password: ValidationItem(error: 'Al menos 8 caracteres'));
    }
    notifyListeners();
  }

  changeconfirmPassword(String value) {
    if (value.length >= 5) {
      _state = _state.copyWith(
          confirmPassword: ValidationItem(value: value, error: ''));
    } else {
      _state = _state.copyWith(
          confirmPassword: ValidationItem(error: 'Al menos 8 caracteres'));
    }
    notifyListeners();
  }
}
