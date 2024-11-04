// ignore: camel_case_types
class Respuesta {
  final String result;
  final Map<String, dynamic>? data;
  final String? error;

  Respuesta({required this.result, required this.data, required this.error});

  factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
      result: json['result'], data: json['data'], error: json['error']);
  Map<String, dynamic> toJson() =>
      {"result": result, "data": data, "error": error};

  @override
  String toString() {
    return "Respuesta(result: $result, data: $data, error: $error)";
  }
}
