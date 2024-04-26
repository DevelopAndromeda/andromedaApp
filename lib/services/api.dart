import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

String? endPoint = dotenv.env['ENDPOINT'];
String? tokenAdmin = dotenv.env['TOKEN_ADMIN'];
String? tokenIntegracion = dotenv.env['TOKEN_INTEGRATION'];

Map<String, String> _headers = <String, String>{
  'Content-type': 'application/json',
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
    default:
      token = '';
      break;
  }
  return token;
}

Future<dynamic> get(String? tokenCustomer, String type, String url) async {
  try {
    final TOKEN = getTokenHeader(type, tokenCustomer);
    print(Uri.parse(endPoint! + url));
    if (TOKEN.isNotEmpty) {
      _headers["Authorization"] = TOKEN;
    } else {
      _headers.remove("Authorization");
    }
    final resp = await http.get(Uri.parse(endPoint! + url), headers: _headers);
    if (resp.statusCode < 500) {
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
    final TOKEN = getTokenHeader(type, tokenCustomer);
    print('Endpoint');
    print(Uri.parse(endPoint! + url));
    print('Paramas');
    print(params);
    print('encoded');
    print(jsonEncode(params));
    if (TOKEN.isNotEmpty) {
      _headers["Authorization"] = TOKEN;
    } else {
      _headers.remove("Authorization");
    }
    print('headers');
    print(_headers);
    final resp = await http.post(Uri.parse(endPoint! + url),
        headers: _headers, body: jsonEncode(params));
    if (resp.statusCode < 500) {
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
    final TOKEN = getTokenHeader(type, tokenCustomer);
    print(Uri.parse(endPoint! + url + id));
    print(params);
    print('headers');
    print(_headers);
    if (TOKEN.isNotEmpty) {
      _headers["Authorization"] = TOKEN;
    } else {
      _headers.remove("Authorization");
    }
    //_headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp = await http.put(Uri.parse(endPoint! + url + id),
        headers: _headers, body: jsonEncode(params));
    if (resp.statusCode < 500) {
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}

Future<dynamic> delete(String? tokenCustomer, String type, String url) async {
  try {
    final TOKEN = getTokenHeader(type, tokenCustomer);
    print('delete');
    print(Uri.parse(endPoint! + url));
    //_headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    if (TOKEN.isNotEmpty) {
      _headers["Authorization"] = TOKEN;
    } else {
      _headers.remove("Authorization");
    }
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
