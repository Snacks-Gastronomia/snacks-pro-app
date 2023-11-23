// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ItemStock {
  final String title;
  final String description;
  final String measure;
  final int document;
  final DateTime dateTime;
  final double value;
  final double amount;
  final double? consume;
  final double? losses;

  ItemStock({
    required this.title,
    required this.description,
    required this.measure,
    required this.document,
    required this.dateTime,
    required this.value,
    required this.amount,
    this.consume,
    this.losses,
  });

  ItemStock copyWith({
    String? title,
    String? description,
    String? measure,
    int? document,
    DateTime? dateTime,
    double? value,
    double? amount,
    double? consume,
    double? losses,
  }) {
    return ItemStock(
      title: title ?? this.title,
      description: description ?? this.description,
      measure: measure ?? this.measure,
      document: document ?? this.document,
      dateTime: dateTime ?? this.dateTime,
      value: value ?? this.value,
      amount: amount ?? this.amount,
      consume: consume ?? this.consume,
      losses: losses ?? this.losses,
    );
  }

  factory ItemStock.initial() {
    return ItemStock(
      title: 'title',
      description: 'description',
      measure: 'measure',
      document: 0,
      dateTime: DateTime.now(),
      value: 0,
      amount: 0,
      consume: 0,
      losses: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'measure': measure,
      'document': document,
      'dateTime': Timestamp.fromDate(dateTime),
      'value': value,
      'amount': amount,
      'losses': losses,
      'consume': consume,
    };
  }

  factory ItemStock.fromMap(Map<String, dynamic> map) {
    return ItemStock(
      title: map['title'] as String,
      description: map['description'] as String,
      measure: map['measure'] as String,
      document: map['document'] as int,
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      value: map['value'] as double,
      amount: map['amount'] as double,
      losses: map['losses'] != null
          ? double.tryParse(map['losses'].toString())
          : null,
      consume: map['consume'] != null
          ? double.tryParse(map['consume'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemStock.fromJson(String source) =>
      ItemStock.fromMap(json.decode(source) as Map<String, dynamic>);
}
