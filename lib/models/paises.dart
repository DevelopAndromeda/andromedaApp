class Pais {
  final String id;
  final String name;
  final String code;

  Pais({required this.id, required this.name, required this.code});

  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
  Map<String, dynamic> toJson() => {"id": id, "name": name, "code": code};

  @override
  String toString() {
    return "Pais(id: $id, name: $name, code: $code)";
  }
}
