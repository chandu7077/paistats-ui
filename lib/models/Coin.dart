class Coin {
  final String symbol;
  final String base;
  final String quote;
  final String name;

  Coin(
      {required this.symbol,
      required this.base,
      required this.quote,
      required this.name});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
        symbol: json["symbol"],
        base: json["base"],
        quote: json["quote"],
        name: json["name"]);
  }
}
