import 'dart:async';
import 'dart:convert';

import 'package:appandromeda/services/api.dart';
import 'package:appandromeda/models/paises.dart';
import 'package:appandromeda/models/estados.dart';
import 'package:appandromeda/models/ciudades.dart';
import 'package:appandromeda/models/status.dart';

class CatalogService {
  Future<List<Pais>> fetchPaises() async {
    final responseJson = json.decode("""
    {
      "data": [
        {
          "id": "1",
          "name": "México",
          "code": "MX"
        }
      ]
    }
    """);

    return (responseJson['data'] as List)
        .map((data) => Pais.fromJson(data))
        .toList();
  }

  Future<List<Estado>> fetchEstados(String code) async {
    //Llenar base de datos local
    final responseJson = await get('', '', 'states?countryCode=$code');
    if (responseJson == null) {
      //print('no hay datos en endpoint');
      return [];
    }

    return (responseJson['items'] as List)
        .map((data) => Estado.fromJson(data))
        .toList();
  }

  Future<List<Ciudad>> fetchCiudades(String code) async {
    print('code estado: $code');
    final responseJson =
        await get('', 'integration', 'product/cities?search=$code');
    if (responseJson == null) {
      //print('no hay datos en endpoint');
      return [];
    }

    return (responseJson['items'] as List)
        .map((data) => Ciudad.fromJson(data))
        .toList();
  }

  Future<List<Status>> fetchStatus() async {
    final responseJson = await get('', 'integration', 'order/statuses');
    if (responseJson == null) {
      //print('no hay datos en endpoint');
      return [];
    }

    List<Status> status = [];
    for (dynamic data in responseJson) {
      if (data['value'] != "table_free") {
        status.add(Status.fromJson(data));
      }
    }

    return status;

    //return (responseJson as List).map((data) => Status.fromJson(data)).toList();
  }
}

class NetworkError extends Error {}
