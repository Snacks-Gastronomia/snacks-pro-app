// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'stock_cubit.dart';

class StockState {
  final String title;
  final String document;
  final String unit;
  final String volume;
  final String date;
  final String time;
  final String value;
  final String description;
  final DateTime created_at;
  final ItemStock selected;
  final bool isEmpty;
  final AppStatus status;

  StockState({
    required this.title,
    required this.document,
    required this.unit,
    required this.volume,
    required this.date,
    required this.time,
    required this.value,
    required this.description,
    required this.selected,
    required this.isEmpty,
    required this.created_at,
    this.status = AppStatus.initial,
  });

  factory StockState.initial() {
    return StockState(
        title: "",
        document: "",
        unit: "",
        volume: "",
        date: "",
        time: "",
        value: "",
        description: "",
        created_at: DateTime.now(),
        selected: ItemStock.getDefault(),
        isEmpty: false);
  }

  StockState copyWith({
    String? title,
    String? document,
    String? unit,
    String? volume,
    String? date,
    String? time,
    String? value,
    String? description,
    DateTime? created_at,
    ItemStock? selected,
    bool? isEmpty,
    AppStatus? status,
  }) {
    return StockState(
      title: title ?? this.title,
      document: document ?? this.document,
      unit: unit ?? this.unit,
      volume: volume ?? this.volume,
      date: date ?? this.date,
      time: time ?? this.time,
      value: value ?? this.value,
      description: description ?? this.description,
      created_at: created_at ?? this.created_at,
      selected: selected ?? this.selected,
      isEmpty: isEmpty ?? this.isEmpty,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'document': document,
      'unit': unit,
      'volume': double.parse(volume),
      'date': date,
      'time': time,
      'value': value,
      'description': description,
      'created_at': created_at
    };
  }

  Map<String, dynamic> toMapLoss() {
    return {
      'unit': unit,
      'volume': double.parse(volume),
      'date': date,
      'time': time,
      'description': description,
      'created_at': created_at
    };
  }

  factory StockState.fromMap(Map<String, dynamic> map) {
    return StockState(
      title: map['title'] ?? '',
      document: map['document'] ?? '',
      unit: map['unit'] ?? '',
      volume: map['volume'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      value: map['value'] ?? '',
      description: map['description'] ?? '',
      selected: ItemStock.fromMap(map['selected']),
      isEmpty: map['isEmpty'] ?? false,
      created_at: map['isEmpty'],
    );
  }

  @override
  String toString() {
    return 'StockState(title: $title, document: $document, unit: $unit, volume: $volume, date: $date, time: $time, value: $value, description: $description, selected: $selected, isEmpty: $isEmpty, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockState &&
        other.title == title &&
        other.document == document &&
        other.unit == unit &&
        other.volume == volume &&
        other.date == date &&
        other.time == time &&
        other.value == value &&
        other.description == description &&
        other.isEmpty == isEmpty &&
        other.status == status;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        document.hashCode ^
        unit.hashCode ^
        volume.hashCode ^
        date.hashCode ^
        time.hashCode ^
        value.hashCode ^
        description.hashCode ^
        selected.hashCode ^
        isEmpty.hashCode ^
        status.hashCode;
  }
}
