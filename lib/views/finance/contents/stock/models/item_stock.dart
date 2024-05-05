// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class ItemStock {
  final String id;
  final String unit;
  final String title;
  final DateTime created_at;
  final double losses;
  final double consumed;
  final double total;

  ItemStock({
    required this.id,
    required this.unit,
    required this.title,
    required this.created_at,
    required this.losses,
    required this.consumed,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'created_at': created_at.millisecondsSinceEpoch,
      'losses': losses,
      'consumed': consumed,
      'total': total,
    };
  }

  static ItemStock getDefault() {
    return ItemStock(
      id: 'default_id',
      unit: '',
      title: 'default_title',
      created_at: DateTime.now(),
      losses: 0.0,
      consumed: 0.0,
      total: 0.0,
    );
  }

  factory ItemStock.fromMap(Map<String, dynamic> map) {
    return ItemStock(
      id: map['id'] ?? '',
      unit: map['unit'] as String,
      title: map['title'] as String,
      created_at: map['created_at'].toDate() as DateTime,
      losses: double.parse(map['losses'].toString()),
      consumed: double.parse(map['consumed'].toString()),
      total: double.parse(map['total'].toString()),
    );
  }
  factory ItemStock.fromData(QueryDocumentSnapshot<Map<String, dynamic>> raw) {
    var map = raw.data();
    log(map.toString());
    return ItemStock(
      id: raw.id,
      unit: map['unit'] ?? "",
      title: map['title'] ?? "",
      created_at: map['created_at'].toDate() as DateTime,
      losses: double.parse(map['losses'].toString()),
      consumed: double.parse(map['consumed'].toString()),
      total: double.parse(map['total'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemStock.fromJson(String source) =>
      ItemStock.fromMap(json.decode(source) as Map<String, dynamic>);

  ItemStock copyWith({
    String? id,
    String? unit,
    String? title,
    DateTime? created_at,
    double? losses,
    double? consumed,
    double? total,
  }) {
    return ItemStock(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      title: title ?? this.title,
      created_at: created_at ?? this.created_at,
      losses: losses ?? this.losses,
      consumed: consumed ?? this.consumed,
      total: total ?? this.total,
    );
  }
}
