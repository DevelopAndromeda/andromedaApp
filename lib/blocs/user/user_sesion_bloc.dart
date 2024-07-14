import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/services/customer.dart';
import 'package:andromeda/utilities/constanst.dart';

abstract class UserSesionState {}

class InitializeState extends UserSesionState {}

class UserLoadingState extends UserSesionState {
  bool isLoading;
  UserLoadingState({required this.isLoading});
}

class UserSesionLogic extends Cubit<UserSesionState> {
  final CustomerService customerService;
  //final CacheToken _cacheToken;
  UserSesionLogic(this.customerService) : super(InitializeState());

  Future updateUserLogic(dynamic data, BuildContext context) async {
    emit(UserLoadingState(isLoading: true));
    await customerService.updateInfo(data).then((value) {
      emit(UserLoadingState(isLoading: false));
      if (value.result == 'ok') {
        responseSuccessWarning(context, value.data!['data']);
      } else {
        responseErrorWarning(context, value.data!['data']);
      }
    }).onError((error, stackTrace) {
      responseErrorWarning(context, 'Usuario y/o Correo incorrecto');
      emit(UserLoadingState(isLoading: false));
    });
  }

  Future updateImgLogic(File img, BuildContext context) async {
    await customerService.updateImg(img).then((value) {
      emit(UserLoadingState(isLoading: false));
      if (value.result == 'ok') {
        responseSuccessWarning(context, value.data!['data']);
      } else {
        responseErrorWarning(context, value.data!['data']);
      }
    }).onError((error, stackTrace) {
      responseErrorWarning(context, 'Usuario y/o Correo incorrecto');
      emit(UserLoadingState(isLoading: false));
    });
  }

  Future updatePasswordLogic(dynamic data, BuildContext context) async {
    emit(UserLoadingState(isLoading: true));
    await customerService.updatePassword(data).then((value) {
      emit(UserLoadingState(isLoading: false));
      if (value.result == 'ok') {
        responseSuccessWarning(context, value.data!['data']);
      } else {
        responseErrorWarning(context, value.data!['data']);
      }
    }).onError((error, stackTrace) {
      responseErrorWarning(context, 'Usuario y/o Correo incorrecto');
      emit(UserLoadingState(isLoading: false));
    });
  }

  /*Future recoveryLogic(String email, BuildContext context) async {
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
      } else {
        responseErrorWarning(context, value.data?['data']);
      }
    }).onError((error, stackTrace) {
      emit(SignUpLoadingState(isLoading: false));
    });
  }*/
}
