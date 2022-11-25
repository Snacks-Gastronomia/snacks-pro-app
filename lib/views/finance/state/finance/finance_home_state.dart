part of 'finance_home_cubit.dart';

class Expense {
  String name;
  double value;
  Expense({
    required this.name,
    required this.value,
  });

  factory Expense.initial() => Expense(name: "", value: 0);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
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

class FinanceHomeState {
  final double budget;
  final double expenses_value;
  final int expenses_length;
  final BankModel bankInfo;
  final Expense expenseAUX;
  final Restaurant? restaurantAUX;
  final AppStatus status;
  FinanceHomeState(
      {required this.budget,
      required this.expenses_value,
      required this.expenses_length,
      required this.bankInfo,
      required this.status,
      required this.expenseAUX,
      required this.restaurantAUX});

  factory FinanceHomeState.initial() => FinanceHomeState(
      expenseAUX: Expense.initial(),
      restaurantAUX: null,
      status: AppStatus.initial,
      budget: 0,
      expenses_value: 0,
      expenses_length: 0,
      bankInfo: BankModel.initial());

  FinanceHomeState copyWith({
    double? budget,
    double? expenses_value,
    int? expenses_length,
    BankModel? bankInfo,
    AppStatus? status,
    Expense? expenseAUX,
    Restaurant? restaurantAUX,
  }) {
    return FinanceHomeState(
      expenseAUX: expenseAUX ?? this.expenseAUX,
      restaurantAUX: restaurantAUX,
      budget: budget ?? this.budget,
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
        other.bankInfo == bankInfo &&
        other.expenseAUX == expenseAUX &&
        other.restaurantAUX == restaurantAUX &&
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
}
