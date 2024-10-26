import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/services/order.dart';

import '../../utilities/constanst.dart';
//import 'package:appandromeda/utilities/constanst.dart';

abstract class OrdenState {}

class InitializeState extends OrdenState {}

class OrdenLoadingState extends OrdenState {
  bool isLoading;
  OrdenLoadingState({required this.isLoading});
}

/*class SignUpLoadingState extends OrdenState {
  bool isLoading;
  SignUpLoadingState({required this.isLoading});
}

class RecoveryLoadingState extends OrdenState {
  bool isLoading;
  RecoveryLoadingState({required this.isLoading});
}*/

class OrdenLogic extends Cubit<OrdenState> {
  final OrderService orderService;
  //final CacheToken _cacheToken;
  OrdenLogic(this.orderService) : super(InitializeState());

  Future generateOrderLogic(
      Map<String, dynamic> orden, BuildContext context) async {
    emit(OrdenLoadingState(isLoading: true));

    await orderService.createOrder(orden).then((response) {
      emit(OrdenLoadingState(isLoading: false));
      //print('response');
      //print(response);
      if (response.result == 'ok') {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Reserva Realizada'),
            content: Text(
                'Tu reserva con numero: ${response.data?['id']}, ha sido realizada con éxito.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                // ignore: prefer_const_constructors
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        //print('error');
        //print(response.data!['message']);
        responseErrorWarning(context, response.data!['message']);
      }
    }).onError((error, stackTrace) {
      //print(error);
      responseErrorWarning(context, 'Ocurrio un Error');
      emit(OrdenLoadingState(isLoading: false));
    });
    ;
    /*final Map<String, dynamic> data = {
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
      print(error);
      responseErrorWarning(context, 'Ocurrio un Error');
      emit(OrdenLoadingState(isLoading: false));
    });*/
  }
}
