part of 'finance_home_cubit.dart';

class FinanceHomeState {
  final double budget;
  final double expenses;
  final BankModel bankInfo;
  final AppStatus status;
  FinanceHomeState({
    required this.budget,
    required this.expenses,
    required this.bankInfo,
    required this.status,
  });

  factory FinanceHomeState.initial() => FinanceHomeState(
      status: AppStatus.initial,
      budget: 0,
      expenses: 0,
      bankInfo: BankModel.initial());

  FinanceHomeState copyWith({
    double? budget,
    double? expenses,
    BankModel? bankInfo,
    AppStatus? status,
  }) {
    return FinanceHomeState(
      budget: budget ?? this.budget,
      expenses: expenses ?? this.expenses,
      bankInfo: bankInfo ?? this.bankInfo,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FinanceHomeState &&
        other.budget == budget &&
        other.expenses == expenses &&
        other.bankInfo == bankInfo &&
        other.status == status;
  }

  @override
  int get hashCode {
    return budget.hashCode ^
        expenses.hashCode ^
        bankInfo.hashCode ^
        status.hashCode;
  }
}
