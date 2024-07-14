class Status {
  final String label;
  final String value;

  Status({required this.label, required this.value});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      label: json['label'],
      value: json['value'],
    );
  }
  Map<String, dynamic> toJson() => {"label": label, "value": value};

  @override
  String toString() {
    return "Status(label: $label, value: $value)";
  }
}
