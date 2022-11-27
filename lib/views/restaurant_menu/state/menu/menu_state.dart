part of 'menu_cubit.dart';

class MenuState extends Equatable {
  final Item item;
  final String selected;
  final List<Ingredient> ingredients;
  final AppStatus status;
  MenuState({
    required this.item,
    required this.selected,
    required this.ingredients,
    required this.status,
  });

  factory MenuState.initial() => MenuState(
        status: AppStatus.initial,
        ingredients: [],
        item: Item.initial(),
        selected: "",
      );

  MenuState copyWith({
    Item? item,
    String? selected,
    List<Ingredient>? ingredients,
    AppStatus? status,
  }) {
    return MenuState(
      item: item ?? this.item,
      selected: selected ?? this.selected,
      ingredients: ingredients ?? this.ingredients,
      status: status ?? this.status,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'item': item.toMap(),
  //     'selected': selected,
  //     'ingredients': ingredients.map((x) => x.toMap()).toList(),
  //     'status': status.toMap(),
  //   };
  // }

  // factory MenuState.fromMap(Map<String, dynamic> map) {
  //   return MenuState(
  //     item: Item.fromMap(map['item']),
  //     selected: map['selected'] ?? '',
  //     ingredients: List<Ingredient>.from(map['ingredients']?.map((x) => Ingredient.fromMap(x))),
  //     status: AppStatus.fromMap(map['status']),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MenuState(item: $item, selected: $selected, ingredients: $ingredients, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuState &&
        other.item == item &&
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
