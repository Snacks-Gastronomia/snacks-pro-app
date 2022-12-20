part of 'stock_cubit.dart';

class StockState {
  final String title;
  final String unit;
  final String volume;
  final String doc;
  final Map selected;
  final bool isEmpty;
  final AppStatus status;
  StockState({
    required this.title,
    required this.unit,
    required this.doc,
    required this.volume,
    required this.selected,
    required this.isEmpty,
    required this.status,
  });

  factory StockState.initial() => StockState(
      unit: "kg",
      title: "",
      isEmpty: true,
      volume: "",
      doc: "",
      selected: {},
      status: AppStatus.initial);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockState &&
        other.title == title &&
        other.volume == volume &&
        other.doc == doc &&
        other.status == status &&
        other.unit == unit &&
        other.isEmpty == isEmpty &&
        other.selected == selected;
  }

  @override
  int get hashCode => title.hashCode ^ volume.hashCode ^ selected.hashCode;

  StockState copyWith({
    String? title,
    String? volume,
    String? unit,
    String? doc,
    bool? isEmpty,
    Map? selected,
    AppStatus? status,
  }) {
    return StockState(
      status: status ?? this.status,
      doc: doc ?? this.doc,
      title: title ?? this.title,
      volume: volume ?? this.volume,
      selected: selected ?? this.selected,
      unit: unit ?? this.unit,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'unit': unit, 'volume': volume, 'current': volume};
  }
}
