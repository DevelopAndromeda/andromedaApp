import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String endPoint = '';
const String tokenAdmin = '';

Map<String, String> _headers = <String, String>{
  'Content-type': 'application/json',
  'Authorization': 'Bearer $tokenAdmin',
};

Future<dynamic> get(String url, Map<String, String>? params) async {
  final resp = await http.get(Uri.parse(endPoint + url), headers: _headers);
  if (resp.statusCode == 200) {
    return json.decode(resp.body);
  } else {
    throw Exception('Failed');
  }
}

Future<dynamic> post(String url, Object params) async {
  final resp = await http.post(Uri.parse(endPoint + url),
      headers: _headers, body: jsonEncode(params));
  if (resp.statusCode == 200) {
    return json.decode(resp.body);
  } else {
    throw Exception('Failed');
  }
}
