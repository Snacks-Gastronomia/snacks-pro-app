import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LossesStock {
  DateTime dateTime;
  String description;
  double losses;
  String title;
  LossesStock({
    required this.dateTime,
    required this.description,
    required this.losses,
    required this.title,
  });

  LossesStock copyWith({
    DateTime? dateTime,
    String? description,
    double? losses,
    String? title,
  }) {
    return LossesStock(
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      losses: losses ?? this.losses,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateTime': Timestamp.fromDate(dateTime),
      'description': description,
      'losses': losses,
      'title': title,
    };
  }

  factory LossesStock.fromMap(Map<String, dynamic> map) {
    return LossesStock(
      dateTime: (map['dateTime'] ?? Timestamp.now()).toDate(),
      description: map['description'] as String,
      losses: double.tryParse(map['losses'].toString()) as double,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LossesStock.fromJson(String source) =>
      LossesStock.fromMap(json.decode(source) as Map<String, dynamic>);
}
