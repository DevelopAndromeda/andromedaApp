class Categoria {
  final int id;
  final String name;

  Categoria({required this.id, required this.name});

  factory Categoria.fromJson(Map<String, dynamic> json) =>
      Categoria(id: json['id'], name: json['name']);
  Map<String, dynamic> toJson() => {"id": id, "name": name};

  @override
  String toString() {
    return "Categoria(id: $id, name: $name)";
  }
}
