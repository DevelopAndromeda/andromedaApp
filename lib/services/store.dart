import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';
import 'package:andromeda/models/response.dart';

class StoreService {
  Future<Respuesta> firstSection() async {
    try {
      final firstSection = await get('', 'integration',
          'products/?searchCriteria[filterGroups][0][filters][0][field]=category_string&searchCriteria[filterGroups][0][filters][0][value]=%25destacados%25&searchCriteria[filterGroups][0][filters][0][conditionType]=like');

      if (firstSection.isEmpty) {
        return Respuesta(
            result: 'fail', data: {'data': 'Error en Api'}, error: null);
      }

      return Respuesta(
          result: 'ok',
          data: {
            'data': firstSection,
          },
          error: null);
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> secondSection() async {
    try {
      final secondSection = await get('', 'integration',
          'threedadv-catalog/most-viewed?pageSize=10&city=2');

      if (secondSection.isEmpty) {
        return Respuesta(
            result: 'fail', data: {'data': 'Error en Api'}, error: null);
      }

      return Respuesta(
          result: 'ok',
          data: {
            'data': secondSection,
          },
          error: null);
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> allRestaurants() async {
    try {
      final allRestaurants = await get('', 'integration',
          'products/?searchCriteria[sortOrders][0][direction]=ASC');

      if (allRestaurants.isEmpty) {
        return Respuesta(
            result: 'fail', data: {'data': 'Error en Api'}, error: null);
      }

      return Respuesta(
          result: 'ok',
          data: {
            'data': allRestaurants,
          },
          error: null);
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> myStores() async {
    try {
      final session = await serviceDB.instance.getById('users', 'id_user', 1);
      if (session.isEmpty) {
        return Respuesta(
            result: 'fail',
            data: {'data': 'Ingresa sesion para continuar'},
            error: 'Error: Api');
      }

      final stores = await get('', 'integration',
          'products/?searchCriteria[filterGroups][0][filters][0][field]=created_by&searchCriteria[filterGroups][0][filters][0][value]=${session[0]['id']}&searchCriteria[filterGroups][0][filters][0][conditionType]=eq');

      if (stores.isNotEmpty) {
        return Respuesta(result: 'ok', data: stores, error: null);
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

  Future<Respuesta> getById(id) async {
    try {
      final product = await get('', 'integration',
          'products/?searchCriteria[filterGroups][0][filters][0][field]=entity_id&searchCriteria[filterGroups][0][filters][0][condition_type]=eq&searchCriteria[filterGroups][0][filters][0][value]=$id');

      if (product.isEmpty) {
        return Respuesta(
            result: 'fail', data: {'data': 'Error en Api'}, error: null);
      }

      return Respuesta(
          result: 'ok',
          data: {
            'data': product,
          },
          error: null);
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }
}

class NetworkError extends Error {}
