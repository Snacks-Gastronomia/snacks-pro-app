import 'dart:convert';
import 'package:snacks_pro_app/models/item_model.dart';

class Order {
  final Item item;
  int amount;
  String observations;
  List<String> extras;
  // final String restaurant_id;
  Order({
    required this.item,
    this.amount = 1,
    this.extras = const [],
    required this.observations,
    // required this.restaurant_id,
  });

  Order copyWith({
    Item? item,
    int? amount,
    String? observations,
    // String? restaurant_id,
  }) {
    return Order(
      item: item ?? this.item,
      amount: amount ?? this.amount,
      observations: observations ?? this.observations,
      // restaurant_id: restaurant_id ?? this.restaurant_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'amount': amount,
      'observations': observations,
      // 'restaurant_id': restaurant_id,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      item: Item.fromMap(map['item']),
      amount: map['amount']?.toInt() ?? 0,
      observations: map['observations'] ?? '',
      extras: List.from(map['extras'] ?? []),
      // restaurant_id: map['restaurant_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
