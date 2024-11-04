import 'package:appandromeda/services/api.dart';
import 'package:appandromeda/services/db.dart';
//import 'package:appandromeda/services/storage.dart';

import 'package:appandromeda/models/response.dart';
import 'package:appandromeda/utilities/constanst.dart';

class AuthService {
  Future<Respuesta> logIn(dynamic data) async {
    //serviceDB.instance.cleanAllTable();
    //serviceDB.instance.deleteDatabase();
    try {
      final login =
          await post('', 'admin', 'integration/customer/token', data, '');
      //print(data);
      //print(login);
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

      //final customer = await get(login, 'integration', 'customers/me');
      final customer = await get(login, 'custom', 'customers/me');
      if (customer != null) {
        data['id'] = customer['id'] ?? '';
        data['nombre'] = customer['firstname'] ?? '';
        data['apellido_paterno'] = customer['lastname'] ?? '';
        data['group_id'] = customer['group_id'] ?? '';

        if (customer['custom_attributes'] != null &&
            customer['custom_attributes'].isNotEmpty) {
          data['zip_code'] =
              getCustomAttribute(customer['custom_attributes'], 'zip_code') ??
                  '';
          data['name_city'] =
              getCustomAttribute(customer['custom_attributes'], 'name_city') ??
                  '';
          data['name_business'] = getCustomAttribute(
                  customer['custom_attributes'], 'name_business') ??
              '';
          data['rfc_id'] =
              getCustomAttribute(customer['custom_attributes'], 'rfc_id') ?? '';
          data['telefono'] = getCustomAttribute(
                  customer['custom_attributes'], 'number_phone') ??
              '';
          data['genero'] =
              getCustomAttribute(customer['custom_attributes'], 'gender') ?? '';
          /*data['img_profile'] = getCustomAttribute(
                  customer['custom_attributes'], 'profile_icon') ??
              '';*/
          /*StorageService().saveToStorage(
              'img_profile',
              getCustomAttribute(
                      customer['custom_attributes'], 'profile_icon') ??
                  '');*/
        }
      }

      /*final customerExtra =
          await get('', 'integration', 'customers/${customer['id']}');
      if (customerExtra != null) {
        print('customerExtra');
        print(customerExtra);
        data['img_profile'] =
            getCustomAttribute(customer['custom_attributes'], 'profile_icon') ??
                '';
      }*/

      final user = await serviceDB.instance.getById('users', 'id_user', 1);
      //Si existen datos en base de datos local actualizamos datos en mapa
      //print(user);
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
      print(e.toString());
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
      List<Map<String, dynamic>> customAttributes = [];
      Map<String, dynamic> newCustomer = {
        'customer': {
          'email': data['email'],
          'firstname': data['firstname'],
          'lastname': data['lastname'],
          'group_id': data['group_id'],
        },
        'password': data['password'],
      };
      if (data['group_id'] == 4) {
        if (data['rfc_id'] != null) {
          customAttributes
              .add({"attribute_code": "rfc_id", "value": data['rfc_id']});
        }

        if (data['name_business'] != null) {
          customAttributes.add({
            "attribute_code": "name_business",
            "value": data['name_business']
          });
        }
      } else {
        newCustomer['customer']['gender'] = data['gender'];

        if (data['telefono'] != null) {
          customAttributes.add(
              {"attribute_code": "number_phone", "value": data['telefono']});
        }

        if (data['zip_code'] != null) {
          customAttributes
              .add({"attribute_code": "zip_code", "value": data['zip_code']});
        }

        if (data['name_city'] != null) {
          customAttributes
              .add({"attribute_code": "name_city", "value": data['name_city']});
        }
      }

      newCustomer['customer']['customAttributes'] = customAttributes;

      //Llamada a endpoint
      final registro = await post('', 'admin', 'customers', newCustomer, '');
      //print(registro);

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

      return Respuesta(
          result: 'ok',
          data: {
            'data':
                'Para continuar por favor, revisa tu cuenta de correo, te enviamos un correo',
          },
          error: null);

      //return logIn({'username': data['email'], 'password': data['password']});
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }
}

class NetworkError extends Error {}
