import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

String? endPoint = dotenv.env['ENDPOINT'];
String? endPointV2 = dotenv.env['ENDPOINT_V2'];
String? tokenAdmin = dotenv.env['TOKEN_ADMIN'];
String? tokenIntegracion = dotenv.env['TOKEN_INTEGRATION'];

Map<String, String> _headers = <String, String>{
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

String getTokenHeader(String type, String? tokenCustomer) {
  Map<String, String> map = {
    'admin': 'Bearer ${dotenv.env['TOKEN_ADMIN']!}',
    'integration': 'Bearer ${dotenv.env['TOKEN_INTEGRATION']!}',
    'custom': 'Bearer $tokenCustomer'
  };
  return map[type] ?? '';
}

Future<dynamic> get(String? tokenCustomer, String type, String url) async {
  //print('** API_GET **');
  try {
    final token = getTokenHeader(type, tokenCustomer);
    //print(
    //    '************* Endpoint: ${Uri.parse(endPoint! + url)}  *************');
    //print('************* TYPE: $type *************');

    if (token.isNotEmpty) {
      _headers["Authorization"] = token;
    } else {
      _headers.remove("Authorization");
    }
    //print('************* headers: $_headers *************');
    final resp = await http.get(Uri.parse(endPoint! + url), headers: _headers);

    if (resp.statusCode < 500) {
      //print(
      //    '************* API Response: ${json.decode(resp.body)} *************');
      return json.decode(resp.body);
    }
    //print(
    //    '************* API Response code - ${resp.statusCode}: ${json.decode(resp.body)} *************');
  } on Exception catch (_) {
    //print('************* API Exception: $_} *************');
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> post(String? tokenCustomer, String type, String url,
    Object params, String? version) async {
  //print('** API_POST **');
  try {
    final token = getTokenHeader(type, tokenCustomer);
    //print(
    //    '************* Endpoint: ${Uri.parse(version == '' ? endPoint! + url : endPointV2! + url)}  *************');
    //print('************* Paramas: $params *************');
    //print('************* TYPE: $type *************');
    if (token.isNotEmpty) {
      _headers["Authorization"] = token;
    } else {
      _headers.remove("Authorization");
    }
    //print('************* headers: $_headers *************');

    final resp = await http.post(
        Uri.parse(version == '' ? endPoint! + url : endPointV2! + url),
        headers: _headers,
        body: jsonEncode(params));
    if (resp.statusCode < 500) {
      //print(
      //    '************* API Response: ${json.decode(resp.body)} *************');
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    //print('************* API Exception: $_} *************');
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> put(String? tokenCustomer, String type, String url,
    Object params, String id) async {
  //print('** API_PUT **');
  try {
    final token = getTokenHeader(type, tokenCustomer);
    //print(
    //    '************* Endpoint: ${Uri.parse(endPoint! + url + id)}  *************');
    //print('************* Paramas: $params *************');
    //print('************* TYPE: $type *************');
    if (token.isNotEmpty) {
      _headers["Authorization"] = token;
    } else {
      _headers.remove("Authorization");
    }
    //print('************* headers: $_headers *************');
    //_headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp = await http.put(Uri.parse(endPoint! + url + id),
        headers: _headers, body: jsonEncode(params));
    if (resp.statusCode < 500) {
      //print(
      //    '************* API Response: ${json.decode(resp.body)} *************');
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    //print('************* API Exception: $_} *************');
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> delete(String? tokenCustomer, String type, String url) async {
  //print('** API_DELETE **');
  try {
    final token = getTokenHeader(type, tokenCustomer);
    //print(
    //    '************* Endpoint: ${Uri.parse(endPoint! + url)}  *************');
    //print('************* TYPE: $type *************');
    //_headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    if (token.isNotEmpty) {
      _headers["Authorization"] = token;
    } else {
      _headers.remove("Authorization");
    }
    //print('************* headers: $_headers *************');
    final resp =
        await http.delete(Uri.parse(endPoint! + url), headers: _headers);
    if (resp.statusCode == 200) {
      //print(
      //    '************* API Response: ${json.decode(resp.body)} *************');
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    //print('************* API Exception: $_} *************');
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> getDirByGeocoding(String value) async {
  value = value.replaceAll(" ", "+");
  //print(Uri.parse(
  //    'https://maps.googleapis.com/maps/api/geocode/json?address=${value}&key=${dotenv.env['TOKEN_GOOGLE_MAPS']}'));
  final resp = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$value&key=${dotenv.env['TOKEN_GOOGLE_MAPS']}'));
  return json.decode(resp.body);
}
