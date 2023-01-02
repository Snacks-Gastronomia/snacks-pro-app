import 'dart:convert';
import 'package:snacks_pro_app/models/item_model.dart';

class OrderModel {
  final Item item;
  int amount;
  String observations;
  List<String> extras;
  // final String restaurant_id;
  OrderModel({
    required this.item,
    this.amount = 1,
    this.extras = const [],
    required this.observations,
    // required this.restaurant_id,
  });

  OrderModel copyWith({
    Item? item,
    int? amount,
    String? observations,
    // String? restaurant_id,
  }) {
    return OrderModel(
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

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      item: Item.fromMap(map['item']),
      amount: map['amount']?.toInt() ?? 0,
      observations: map['observations'] ?? '',
      extras: List.from(map['extras'] ?? []),
      // restaurant_id: map['restaurant_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
