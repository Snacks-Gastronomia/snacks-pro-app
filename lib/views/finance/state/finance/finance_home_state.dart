part of 'finance_home_cubit.dart';

class FinanceHomeState {
  final double budget;
  final int orders_count;
  final int employees_count;
  final BankModel bankInfo;
  final AppStatus status;
  FinanceHomeState({
    required this.budget,
    required this.orders_count,
    required this.employees_count,
    required this.bankInfo,
    required this.status,
  });

  factory FinanceHomeState.initial() => FinanceHomeState(
      status: AppStatus.initial,
      budget: 0,
      orders_count: 0,
      employees_count: 0,
      bankInfo: BankModel.initial());

  FinanceHomeState copyWith({
    double? budget,
    int? orders_count,
    int? employees_count,
    BankModel? bankInfo,
    AppStatus? status,
  }) {
    return FinanceHomeState(
      budget: budget ?? this.budget,
      orders_count: orders_count ?? this.orders_count,
      employees_count: employees_count ?? this.employees_count,
      bankInfo: bankInfo ?? this.bankInfo,
      status: status ?? this.status,
    );
  }
}
