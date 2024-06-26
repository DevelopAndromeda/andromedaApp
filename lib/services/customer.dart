import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/models/response.dart';
import 'package:andromeda/utilities/constanst.dart';

class CustomerService {
  Future<Respuesta> getFavorites() async {
    try {
      final session = await serviceDB.instance.getById('users', 'id_user', 1);

      if (session.isEmpty) {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ingresa sesion para continuar'},
            error: 'Error: Api');
      }

      final favorites = await get(
        session[0]['token'],
        'custom',
        'wishlist/customer/items',
      );

      /*if (favorites['message'] != null) {
        return respuesta(
            result: 'ok', data: {'data': null}, error: 'Error: Api');
      }*/

      if (favorites.isNotEmpty) {
        return Respuesta(result: 'ok', data: favorites, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'La info esta corrupta'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> getMyOrders() async {
    try {
      final session = await serviceDB.instance.getById('users', 'id_user', 1);

      if (session.isEmpty) {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ingresa sesion para continuar'},
            error: 'Error: Api');
      }

      final history = await get('', 'integration',
          'orders?searchCriteria[filterGroups][0][filters][0][field]=customer_id&searchCriteria[filterGroups][0][filters][0][value]=${session[0]['id']}&searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[sortOrders][0][field]=entity_id&searchCriteria[sortOrders][0][direction]=DESC');

      if (history.isNotEmpty) {
        return Respuesta(result: 'ok', data: history, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'La info esta corrupta'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> deleteFavorite(id) async {
    try {
      final session = await serviceDB.instance.getById('users', 'id_user', 1);
      if (session.isEmpty) {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ingresa sesion para continuar'},
            error: 'Error: Api');
      }
      final borrado = await delete(
          session[0]['token'], 'custom', 'wishlist/customer/item/$id');
      if (borrado != null) {
        return Respuesta(result: 'ok', data: {'data': true}, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ocurrio un error al procesar tus datos'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> changeStatusOrder(id, status) async {
    try {
      final statusOrder =
          await post('', 'integration', 'orders/$id/$status', {}, '');
      print('statusOrder');
      print(statusOrder);
      if (statusOrder != null) {
        return Respuesta(result: 'ok', data: {'data': true}, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ocurrio un error al proecsar tus datos'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> getReservations() async {
    try {
      var sesion = await serviceDB.instance.getById('users', 'id_user', 1);

      if (sesion.isEmpty) {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ingresa sesion para continuar'},
            error: 'Error: Api');
      }

      final reservations = await get(sesion[0]['token'], 'custom',
          'mysalesorders?searchCriteria[currentPage]=1&searchCriteria[pageSize]=10');

      if (reservations.isNotEmpty) {
        return Respuesta(result: 'ok', data: reservations['data'], error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'La info esta corrupta'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> getUserSession() async {
    try {
      final session = await serviceDB.instance.getById('users', 'id_user', 1);

      if (session.isEmpty) {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ingresa sesion para continuar'},
            error: 'Error: Api');
      }

      return Respuesta(result: 'ok', data: session[0], error: null);
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> updateInfo(dynamic data) async {
    try {
      Respuesta seion = await getUserSession();
      if (seion.result == 'fail') {
        return seion;
      }

      List<Map<String, dynamic>> customAttributes = [];
      Map<String, dynamic> newCustomer = {
        'customer': {
          'email': data['email'],
          'firstname': data['firstname'],
          'lastname': data['lastname'],
        },
        'password': seion.data!['password'],
      };

      if (data['telefono'] != null) {
        customAttributes
            .add({"attribute_code": "number_phone", "value": data['telefono']});
      }

      if (data['zip_code'] != null) {
        customAttributes
            .add({"attribute_code": "zip_code", "value": data['zip_code']});
      }

      if (data['name_city'] != null) {
        customAttributes
            .add({"attribute_code": "name_city", "value": data['name_city']});
      }

      if (seion.data!['group_id'] == 4) {
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
      }

      newCustomer['customer']['customAttributes'] = customAttributes;

      print('newCustomer');
      print(newCustomer);

      final updateUser = await put(
          seion.data!['token'], 'custom', 'customers/me', newCustomer, '');

      print('updateUser');
      print(updateUser);

      if (updateUser.isEmpty) {
        return Respuesta(
            result: 'fail', data: {'data': 'Error en EndPoint'}, error: null);
      }

      Map<String, dynamic> datas = {
        'nombre': updateUser['firstname'],
        'apellido_paterno': updateUser['lastname'],
        'username': updateUser['email']
      };

      print(updateUser['custom_attributes']);

      if (updateUser['custom_attributes'].isNotEmpty) {
        datas['zip_code'] =
            getCustomAttribute(updateUser['custom_attributes'], 'zip_code') ??
                '';
        print(1);
        print(datas['zip_code']);
        datas['name_city'] =
            getCustomAttribute(updateUser['custom_attributes'], 'name_city') ??
                '';
        print(2);
        print(datas['name_city']);
        datas['name_business'] = getCustomAttribute(
                updateUser['custom_attributes'], 'name_business') ??
            '';
        print(3);
        print(datas['name_business']);
        datas['rfc_id'] =
            getCustomAttribute(updateUser['custom_attributes'], 'rfc_id') ?? '';
        print(4);
        print(datas['rfc_id']);
        datas['telefono'] = getCustomAttribute(
                updateUser['custom_attributes'], 'number_phone') ??
            '';
        print(5);
        print(datas['telefono']);
      }
      await serviceDB.instance.updateRecord('users', datas, 'id_user', 1);
      return Respuesta(
          result: 'ok',
          data: {
            'data': 'Exito',
          },
          error: null);
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }
}

class NetworkError extends Error {}
