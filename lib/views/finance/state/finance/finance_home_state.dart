part of 'finance_home_cubit.dart';

class Expense {
  String name;
  double value;
  String type;
  Expense({
    required this.name,
    required this.value,
    required this.type,
  });

  factory Expense.initial() => Expense(name: "", type: "", value: 0);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'type': type,
    };
  }
}

class Restaurant {
  String? id;
  String rname;
  String rcategory;
  String oname;
  String ophone;
  Restaurant({
    this.id,
    required this.rname,
    required this.rcategory,
    required this.oname,
    required this.ophone,
  });
}

class Printer {
  final String? id;
  final String name;
  final String? goal;
  final String ip;
  final String restaurant;
  Printer({
    this.id,
    required this.name,
    required this.goal,
    required this.ip,
    required this.restaurant,
  });

  factory Printer.initial() =>
      Printer(name: "", goal: null, ip: "", restaurant: "");

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'goal': goal,
      'ip': ip,
      'restaurant': restaurant,
    };
  }

  Printer copyWith({
    String? id,
    String? name,
    String? goal,
    String? ip,
    String? restaurant,
  }) {
    return Printer(
      id: id ?? this.id,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      ip: ip ?? this.ip,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Printer &&
        other.id == id &&
        other.name == name &&
        other.goal == goal &&
        other.ip == ip &&
        other.restaurant == restaurant;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        goal.hashCode ^
        ip.hashCode ^
        restaurant.hashCode;
  }
}

class FinanceHomeState extends Equatable {
  final double budget;
  final double expenses_value;
  final int expenses_length;
  final int questions_carousel_index;
  final BankModel bankInfo;
  final Expense expenseAUX;
  final Restaurant? restaurantAUX;
  final Printer printerAUX;
  final AppStatus status;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> expensesData;
  FinanceHomeState({
    required this.budget,
    required this.expenses_value,
    required this.expenses_length,
    required this.questions_carousel_index,
    required this.bankInfo,
    required this.expenseAUX,
    required this.restaurantAUX,
    required this.printerAUX,
    required this.status,
    required this.expensesData,
  });

  factory FinanceHomeState.initial() => FinanceHomeState(
      expenseAUX: Expense.initial(),
      restaurantAUX: null,
      printerAUX: Printer.initial(),
      status: AppStatus.initial,
      budget: 0,
      questions_carousel_index: 0,
      expenses_value: 0,
      expenses_length: 0,
      expensesData: [],
      bankInfo: BankModel.initial());

  FinanceHomeState copyWith(
      {double? budget,
      double? expenses_value,
      int? expenses_length,
      int? questions_carousel_index,
      BankModel? bankInfo,
      AppStatus? status,
      Expense? expenseAUX,
      Restaurant? restaurantAUX,
      Printer? printerAUX,
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? expensesData}) {
    return FinanceHomeState(
      expenseAUX: expenseAUX ?? this.expenseAUX,
      restaurantAUX: restaurantAUX,
      expensesData: expensesData ?? this.expensesData,
      budget: budget ?? this.budget,
      printerAUX: printerAUX ?? this.printerAUX,
      questions_carousel_index:
          questions_carousel_index ?? this.questions_carousel_index,
      expenses_length: expenses_length ?? this.expenses_length,
      expenses_value: expenses_value ?? this.expenses_value,
      bankInfo: bankInfo ?? this.bankInfo,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FinanceHomeState &&
        other.budget == budget &&
        other.expenses_value == expenses_value &&
        other.expenses_length == expenses_length &&
        other.questions_carousel_index == questions_carousel_index &&
        other.bankInfo == bankInfo &&
        other.expenseAUX == expenseAUX &&
        other.restaurantAUX == restaurantAUX &&
        other.printerAUX == printerAUX &&
        other.expensesData == expensesData &&
        other.status == status;
  }

  @override
  int get hashCode {
    return budget.hashCode ^
        expenses_value.hashCode ^
        bankInfo.hashCode ^
        expenseAUX.hashCode ^
        restaurantAUX.hashCode ^
        status.hashCode;
  }

  @override
  List<Object> get props {
    return [
      budget,
      expenses_value,
      expenses_length,
      questions_carousel_index,
      bankInfo,
      expenseAUX,
      printerAUX,
      status,
      expensesData,
    ];
  }
}
