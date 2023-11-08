part of 'menu_cubit.dart';

class MenuState extends Equatable {
  final Item item;
  final String selected;
  final List<Ingredient> ingredients;
  final AppStatus status;
  final double? discount;
  const MenuState({
    required this.discount,
    required this.item,
    required this.selected,
    required this.ingredients,
    required this.status,
  });

  factory MenuState.initial() => MenuState(
        status: AppStatus.initial,
        ingredients: const [],
        item: Item.initial(),
        selected: "",
        discount: 0,
      );

  MenuState copyWith({
    Item? item,
    String? selected,
    List<Ingredient>? ingredients,
    AppStatus? status,
    double? discount,
  }) {
    return MenuState(
      item: item ?? this.item,
      discount: discount ?? this.discount,
      selected: selected ?? this.selected,
      ingredients: ingredients ?? this.ingredients,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'MenuState(item: $item, selected: $selected, ingredients: $ingredients, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuState &&
        other.item == item &&
        other.discount == discount &&
        other.selected == selected &&
        listEquals(other.ingredients, ingredients) &&
        other.status == status;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        selected.hashCode ^
        ingredients.hashCode ^
        status.hashCode;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [ingredients];
}
