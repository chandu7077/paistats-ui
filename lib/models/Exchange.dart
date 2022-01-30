class Exchange {
  final String name;

  Exchange({required this.name});

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(name: json["name"]);
  }
}
