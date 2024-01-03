import 'dart:convert';

class ConferenceModel {
  final String? title;
  final int? total;
  final DateTime? date;

  ConferenceModel({
    this.title,
    this.total,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'total': total,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory ConferenceModel.fromMap(Map<String, dynamic> map) {
    return ConferenceModel(
      title: map['title'] != null ? map['title'] as String : null,
      total: map['total'] != null ? map['total'] as int : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConferenceModel.fromJson(String source) =>
      ConferenceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
