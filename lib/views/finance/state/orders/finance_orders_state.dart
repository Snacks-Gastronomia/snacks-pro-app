part of 'finance_orders_cubit.dart';

class FinanceOrdersState {
  final AppStatus status;
  final List<OrderResponse> orders;
  final DateTime interval_start;
  final DateTime interval_end;
  final double totalValue;
  final int totalOrders;
  final int total_orders_monthly;
  final int total_orders_daily;
  final double budget_monthly;
  final double budget_daily;
  final List<dynamic> orders_monthly;
  final List<dynamic> orders_daily;
  final String filter;

  FinanceOrdersState(
      {required this.status,
      required this.orders,
      required this.interval_start,
      required this.interval_end,
      required this.totalValue,
      required this.totalOrders,
      required this.total_orders_monthly,
      required this.total_orders_daily,
      required this.budget_monthly,
      required this.budget_daily,
      required this.orders_monthly,
      required this.orders_daily,
      required this.filter});

  factory FinanceOrdersState.initial() => FinanceOrdersState(
        status: AppStatus.initial,
        orders: [],
        interval_start: DateTime.now(),
        interval_end: DateTime.now(),
        totalValue: 0,
        totalOrders: 0,
        total_orders_monthly: 0,
        total_orders_daily: 0,
        budget_monthly: 0,
        budget_daily: 0,
        orders_monthly: [],
        orders_daily: [],
        filter: 'Todos os itens',
      );

  FinanceOrdersState copyWith(
      {AppStatus? status,
      List<OrderResponse>? orders,
      DateTime? interval_start,
      DateTime? interval_end,
      double? totalValue,
      int? totalOrders,
      int? total_orders_monthly,
      int? total_orders_daily,
      double? budget_monthly,
      double? budget_daily,
      List<dynamic>? orders_monthly,
      List<dynamic>? orders_daily,
      String? filter}) {
    return FinanceOrdersState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        interval_start: interval_start ?? this.interval_start,
        interval_end: interval_end ?? this.interval_end,
        totalValue: totalValue ?? this.totalValue,
        totalOrders: totalOrders ?? this.totalOrders,
        total_orders_monthly: total_orders_monthly ?? this.total_orders_monthly,
        total_orders_daily: total_orders_daily ?? this.total_orders_daily,
        budget_monthly: budget_monthly ?? this.budget_monthly,
        budget_daily: budget_daily ?? this.budget_daily,
        orders_monthly: orders_monthly ?? this.orders_monthly,
        orders_daily: orders_daily ?? this.orders_daily,
        filter: filter ?? this.filter);
  }
}
