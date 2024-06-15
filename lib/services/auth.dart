import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/models/response.dart';
import 'package:andromeda/utilities/constanst.dart';

class AuthService {
  Future<Respuesta> logIn(dynamic data) async {
    //serviceDB.instance.cleanAllTable();
    //serviceDB.instance.deleteDatabase();
    try {
      final login =
          await post('', 'admin', 'integration/customer/token', data, '');
      if (login.runtimeType != String) {
        return Respuesta(
            result: 'fail',
            data: {'data': login['message']},
            error: 'Error: Api');
      }

      /*Map<String, dynamic> data = {
        'username': playload['username'],
        'password': playload['password'],
        'token': login
      };*/
      data['token'] = login;

      final customer = await get(login, 'custom', 'customers/me');
      if (customer != null) {
        data['id'] = customer['id'];
        data['nombre'] = customer['firstname'];
        data['apellido_paterno'] = customer['lastname'];
        data['group_id'] = customer['group_id'];

        if (customer['custom_attributes'].isNotEmpty) {
          data['zip_code'] =
              getCustomAttribute(customer['custom_attributes'], 'zip_code');
          data['name_city'] =
              getCustomAttribute(customer['custom_attributes'], 'name_city');
          data['name_business'] = getCustomAttribute(
              customer['custom_attributes'], 'name_business');
          data['rfc_id'] =
              getCustomAttribute(customer['custom_attributes'], 'rfc_id');
          data['telefono'] =
              getCustomAttribute(customer['custom_attributes'], 'number_phone');
        }
      }

      final user = await serviceDB.instance.getById('users', 'id_user', 1);
      //Si existen datos en base de datos local actualizamos datos en mapa
      if (user.isNotEmpty) {
        await serviceDB.instance.updateRecord('users', data, 'id_user', 1);
      } else {
        //Si no existen datos en base de datos local insertamos datos en mapa
        data['id_user'] = 1;
        await serviceDB.instance.insertRecord('users', data);
      }
      return Respuesta(
          result: 'ok',
          data: {
            'data': 'Inicio de sesion Exitoso',
            'group_id': data['group_id']
          },
          error: null);
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> recovery(dynamic data) async {
    try {
      final updatePassword =
          await put('', 'type', 'customers/', data, 'password');

      if (updatePassword.runtimeType != bool) {
        return Respuesta(
            result: 'fail',
            data: {'data': updatePassword['message']},
            error: null);
      }

      if (updatePassword != null) {
        if (updatePassword) {
          return Respuesta(
              result: 'ok',
              data: {'data': 'Te hemos enviado un correo electronico'},
              error: null);
        }
      }

      return Respuesta(
          result: 'fail',
          data: {'data': 'No pudimos enviar el correo'},
          error: 'Error: Api');
    } catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': e.toString()}, error: 'Error: Api');
    }
  }

  Future<Respuesta> register(dynamic data) async {
    try {
      //Llamada a endpoint
      final registro = await post(
          '',
          'admin',
          'customers',
          {
            'customer': {
              'email': data['email'],
              'firstname': data['firstname'],
              'lastname': data['lastname'],
              'group_id': data['group_id'],
              'gender': data['gender'],
            },
            'password': data['password'],
          },
          '');

      if (registro == null) {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Error al enviar datos'},
            error: 'Error: Api');
      }

      if (registro['message'] != null) {
        return Respuesta(
            result: 'fail',
            data: {'data': registro['message']},
            error: 'Error: Api');
      }

      return logIn({'username': data['email'], 'password': data['password']});
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }
}

class NetworkError extends Error {}
