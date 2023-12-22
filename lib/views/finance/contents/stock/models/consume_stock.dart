import 'dart:convert';

class ConsumeStock {
  int consume;
  String ingredients;
  String month;
  ConsumeStock({
    required this.consume,
    required this.ingredients,
    required this.month,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'consume': consume,
      'ingredients': ingredients,
      'month': month,
    };
  }

  factory ConsumeStock.fromMap(Map<String, dynamic> map) {
    return ConsumeStock(
      consume: map['consume'] as int,
      ingredients: map['ingredients'] as String,
      month: map['month'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsumeStock.fromJson(String source) =>
      ConsumeStock.fromMap(json.decode(source) as Map<String, dynamic>);
}
