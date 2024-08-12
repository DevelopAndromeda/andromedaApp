import 'dart:async';
import 'dart:convert';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/models/paises.dart';
import 'package:andromeda/models/estados.dart';
import 'package:andromeda/models/ciudades.dart';
import 'package:andromeda/models/status.dart';

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
