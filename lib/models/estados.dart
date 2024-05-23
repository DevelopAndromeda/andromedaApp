class Estado {
  final int id;
  final String label;
  final String code;

  Estado({required this.id, required this.label, required this.code});

  factory Estado.fromJson(Map<String, dynamic> json) =>
      Estado(id: json['id'], label: json['label'], code: json['code']);
  Map<String, dynamic> toJson() => {"id": id, "label": label, "code": code};

  @override
  String toString() {
    return "Estado(id: $id, label: $label, code: $code)";
  }
}
