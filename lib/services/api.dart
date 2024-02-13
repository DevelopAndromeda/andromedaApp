import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String endPoint = 'http://82.165.212.67/rest/V1/';
const String tokenAdmin = 'df6yceacc1pt8qinuchuiouryh01luox';
const String tokenIntegracion = '7hgxaab1wmyk0amy8uuf50gzq8ho8pvs';

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
  }
  return token;
}

Future<dynamic> get(String? tokenCustomer, String type, String url) async {
  try {
    _headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp = await http.get(Uri.parse(endPoint + url), headers: _headers);
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
    _headers["Authorization"] = getTokenHeader(type, tokenCustomer);
    final resp = await http.post(Uri.parse(endPoint + url),
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
    final resp = await http.put(Uri.parse(endPoint + url + id),
        headers: _headers, body: jsonEncode(params));
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
  } on Exception catch (_) {
    // make it explicit that this function can throw exceptions
    rethrow;
  }
}
