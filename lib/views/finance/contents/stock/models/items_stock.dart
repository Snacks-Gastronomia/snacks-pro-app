// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemsStock {
  final String title;
  final String description;
  final String measure;
  final int document;
  final DateTime dateTime;
  final double value;
  final double amount;
  final double? losses;

  ItemsStock({
    required this.title,
    required this.description,
    required this.measure,
    required this.document,
    required this.dateTime,
    required this.value,
    required this.amount,
    this.losses,
  });

  ItemsStock copyWith({
    String? title,
    String? description,
    String? measure,
    int? document,
    DateTime? dateTime,
    double? value,
    double? amount,
    double? losses,
  }) {
    return ItemsStock(
      title: title ?? this.title,
      description: description ?? this.description,
      measure: measure ?? this.measure,
      document: document ?? this.document,
      dateTime: dateTime ?? this.dateTime,
      value: value ?? this.value,
      amount: amount ?? this.amount,
      losses: losses ?? this.losses,
    );
  }
}
