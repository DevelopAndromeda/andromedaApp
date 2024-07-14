import 'dart:async';

import 'package:andromeda/services/api.dart';

import 'package:andromeda/models/response.dart';

class OrderService {
  Future<Respuesta> getOptions(String? sku) async {
    try {
      final options = await get('', 'integration', 'products/$sku/options');
      if (options.isNotEmpty) {
        return Respuesta(result: 'ok', data: {"data": options}, error: null);
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
}

class NetworkError extends Error {}
