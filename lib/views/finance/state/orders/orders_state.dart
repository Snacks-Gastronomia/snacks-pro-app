part of 'orders_cubit.dart';

class OrdersState {
  final AppStatus status;
  final int total_orders_monthly;
  final int total_orders_daily;
  final double budget_monthly;
  final double budget_daily;
  final List<dynamic> orders_monthly;
  final List<dynamic> orders_daily;
  OrdersState({
    required this.status,
    required this.total_orders_monthly,
    required this.total_orders_daily,
    required this.budget_monthly,
    required this.budget_daily,
    required this.orders_monthly,
    required this.orders_daily,
  });
  factory OrdersState.initial() => OrdersState(
      status: AppStatus.initial,
      total_orders_monthly: 0,
      total_orders_daily: 0,
      budget_monthly: 0,
      budget_daily: 0,
      orders_monthly: [],
      orders_daily: []);

  OrdersState copyWith({
    AppStatus? status,
    int? total_orders_monthly,
    int? total_orders_daily,
    double? budget_monthly,
    double? budget_daily,
    List<dynamic>? orders_monthly,
    List<dynamic>? orders_daily,
  }) {
    return OrdersState(
      status: status ?? this.status,
      total_orders_monthly: total_orders_monthly ?? this.total_orders_monthly,
      total_orders_daily: total_orders_daily ?? this.total_orders_daily,
      budget_monthly: budget_monthly ?? this.budget_monthly,
      budget_daily: budget_daily ?? this.budget_daily,
      orders_monthly: orders_monthly ?? this.orders_monthly,
      orders_daily: orders_daily ?? this.orders_daily,
    );
  }
}
