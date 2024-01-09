// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ConferenceModel {
  final double dinheiro;
  final double credito;
  final double debito;
  final double pix;
  final double total;
  final Timestamp date;
  ConferenceModel({
    required this.dinheiro,
    required this.credito,
    required this.debito,
    required this.pix,
    required this.total,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dinheiro': dinheiro,
      'credito': credito,
      'debito': debito,
      'pix': pix,
      'total': total,
      'date': date,
    };
  }

  factory ConferenceModel.fromMap(Map<String, dynamic> map) {
    return ConferenceModel(
      dinheiro: map['dinheiro'] as double,
      credito: map['credito'] as double,
      debito: map['debito'] as double,
      pix: map['pix'] as double,
      total: map['total'] as double,
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConferenceModel.fromJson(String source) =>
      ConferenceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
