import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/services/auth.dart';
import 'package:andromeda/utilities/constanst.dart';

abstract class AuthState {}

class InitializeState extends AuthState {}

class LoginLoadingState extends AuthState {
  bool isLoading;
  LoginLoadingState({required this.isLoading});
}

class SignUpLoadingState extends AuthState {
  bool isLoading;
  SignUpLoadingState({required this.isLoading});
}

class RecoveryLoadingState extends AuthState {
  bool isLoading;
  RecoveryLoadingState({required this.isLoading});
}

class AuthLogic extends Cubit<AuthState> {
  final AuthService _authService;
  //final CacheToken _cacheToken;
  AuthLogic(this._authService) : super(InitializeState());

  Future loginLogic(
      String username, String password, BuildContext context) async {
    emit(LoginLoadingState(isLoading: true));
    final Map<String, dynamic> data = {
      'username': username,
      'password': password
    };
    await _authService.logIn(data).then((value) {
      emit(LoginLoadingState(isLoading: false));
      if (value.result == 'ok') {
        responseSuccessWarning(context, value.data?['data']);

        Navigator.pushNamed(context, 'home');

        /*Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);*/
      } else {
        responseErrorWarning(context, value.data?['data']);
      }
    }).onError((error, stackTrace) {
      responseErrorWarning(context, 'Usuario y/o Correo incorrecto');
      emit(LoginLoadingState(isLoading: false));
    });
  }

  Future recoveryLogic(String email, BuildContext context) async {
    emit(RecoveryLoadingState(isLoading: true));

    Map<String, dynamic> data = {"email": email, "template": "email_reset"};

    await _authService.recovery(data).then((value) {
      emit(RecoveryLoadingState(isLoading: false));
      if (value.result == 'ok') {
        responseSuccessWarning(context, value.data?['data']);
      } else {
        responseErrorWarning(context, value.data?['data']);
      }
    }).onError((error, stackTrace) {
      responseErrorWarning(context, 'Error al procesar la api');
      emit(RecoveryLoadingState(isLoading: false));
    });
  }

  Future createAccountLogic(dynamic data, BuildContext context) async {
    emit(SignUpLoadingState(isLoading: true));
    await _authService.register(data).then((value) {
      emit(SignUpLoadingState(isLoading: false));
      if (value.result == 'ok') {
        responseSuccessWarning(context, value.data?['data']);
        //Navigator.pushNamed(context, 'home');
        Navigator.pushNamed(context, 'login');
        /*Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);*/
      } else {
        responseErrorWarning(context, value.data?['data']);
      }
    }).onError((error, stackTrace) {
      emit(SignUpLoadingState(isLoading: false));
    });
  }
}
