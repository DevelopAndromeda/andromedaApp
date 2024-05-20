class Ciudad {
  final String statecity;

  Ciudad({required this.statecity});

  factory Ciudad.fromJson(Map<String, dynamic> json) =>
      Ciudad(statecity: json['statecity']);
  Map<String, dynamic> toJson() => {"statecity": statecity};

  @override
  String toString() {
    return "Ciudad(statecity: $statecity)";
  }
}
