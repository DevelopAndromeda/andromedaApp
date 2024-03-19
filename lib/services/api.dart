import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

String? endPoint = dotenv.env['ENDPOINT'];
String? tokenAdmin = dotenv.env['TOKEN_ADMIN'];
String? tokenIntegracion = dotenv.env['TOKEN_INTEGRATION'];

Map<String, String> _headers = <String, String>{
  'Content-type': 'application/json; charset=utf-8',
};

String getTokenHeader(String type, String? tokenCustomer) {
  String token = '';
  switch (type) {
    case 'admin':
      token = 'Bearer $tokenAdmin';
      break;
    case 'integration':
      token = 'Bearer $tokenIntegracion';
      break;
    case 'custom':
      token = 'Bearer $tokenCustomer';
      break;
  }
  return token;
}

Future<dynamic> get(String? tokenCustomer, String type, String url) async {
  try {
    print(Uri.parse(endPoint! + url));
    _headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp = await http.get(Uri.parse(endPoint! + url), headers: _headers);
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> post(
    String? tokenCustomer, String type, String url, Object params) async {
  try {
    print(Uri.parse(endPoint! + url));
    _headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp = await http.post(Uri.parse(endPoint! + url),
        headers: _headers, body: jsonEncode(params));
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> put(String? tokenCustomer, String type, String url,
    Object params, String id) async {
  try {
    _headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp = await http.put(Uri.parse(endPoint! + url + id),
        headers: _headers, body: jsonEncode(params));
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> delete(String? tokenCustomer, String type, String url) async {
  try {
    print('delete');
    print(Uri.parse(endPoint! + url));
    _headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp =
        await http.delete(Uri.parse(endPoint! + url), headers: _headers);
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}
