import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/models/response.dart';

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
          'orders?searchCriteria[filterGroups][0][filters][0][field]=customer_id&searchCriteria[filterGroups][0][filters][0][value]=${session[0]['id']}&searchCriteria[filterGroups][0][filters][0][conditionType]=eq');

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
            data: {'data': 'Ingresa sesion para continuar'},
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
}

class NetworkError extends Error {}
