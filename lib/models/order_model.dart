import 'dart:convert';
import 'package:snacks_pro_app/models/item_model.dart';

class OrderModel {
  final Item item;
  int amount;
  String observations;
  List<dynamic> extras;
  final dynamic option_selected;
  OrderModel({
    required this.item,
    this.amount = 1,
    this.extras = const [],
    required this.option_selected,
    required this.observations,
    // required this.restaurant_id,
  });

  double get getTotalValue {
    double extra = extras.isNotEmpty
        ? extras
            .map((e) => double.parse(e["value"].toString()))
            .reduce((value, element) => value + element)
        : 0;
    return (double.parse(option_selected["value"].toString()) + extra) * amount;
  }

  OrderModel copyWith({
    Item? item,
    int? amount,
    String? observations,
    dynamic option_selected,
    // String? restaurant_id,
  }) {
    return OrderModel(
      item: item ?? this.item,
      amount: amount ?? this.amount,
      option_selected: option_selected ?? this.option_selected,
      observations: observations ?? this.observations,
      // restaurant_id: restaurant_id ?? this.restaurant_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'amount': amount,
      'observations': observations,
      'option_selected': option_selected,
      // 'restaurant_id': restaurant_id,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      item: Item.fromMap(map['item']),
      amount: map['amount']?.toInt() ?? 0,
      observations: map['observations'] ?? '',
      extras: List.from(map['extras'] ?? []),
      option_selected: map['option_selected'] ?? {},
      // restaurant_id: map['restaurant_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
