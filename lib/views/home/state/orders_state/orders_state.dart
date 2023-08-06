part of 'orders_cubit.dart';

class OrdersState {
  final String payment_method;
  final int table_code;

  final double total;
  final AppStatus status;
  final String? error;
  final String temp_observation;

  OrdersState({
    required this.payment_method,
    required this.table_code,
    required this.total,
    required this.status,
    this.error,
    required this.temp_observation,
  });

  // OrdersState({
  //   required this.cart,
  //   required this.status,
  //   required this.total,
  //   required this.error,
  //   required this.temp_observation,
  // });

  factory OrdersState.initial() => OrdersState(
        payment_method: "",
        table_code: 0,
        status: AppStatus.initial,
        total: 0,
        error: "",
        temp_observation: "",
      );
  // OrdersState copyWith({
  //   List<Order>? cart,
  //   AppStatus? status,
  //   double? total,
  //   String? error,
  //   String? temp_observation,
  //   List<String>? itens_added,
  // }) {
  //   return OrdersState(
  //     cart: cart ?? this.cart,
  //     status: status ?? this.status,
  //     total: total ?? this.total,
  //     error: error ?? this.error,
  //     temp_observation: temp_observation ?? this.temp_observation,
  //   );
  // }

  OrdersState copyWith({
    String? payment_method,
    int? table_code,
    double? total,
    AppStatus? status,
    String? error,
    String? temp_observation,
  }) {
    return OrdersState(
      payment_method: payment_method ?? this.payment_method,
      table_code: table_code ?? this.table_code,
      total: total ?? this.total,
      status: status ?? this.status,
      error: error ?? this.error,
      temp_observation: temp_observation ?? this.temp_observation,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      payment_method,
      table_code,
      total,
      status,
      temp_observation,
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrdersState &&
        other.payment_method == payment_method &&
        other.table_code == table_code &&
        other.total == total &&
        other.status == status &&
        other.error == error &&
        other.temp_observation == temp_observation;
  }

  @override
  int get hashCode {
    return payment_method.hashCode ^
        table_code.hashCode ^
        total.hashCode ^
        status.hashCode ^
        error.hashCode ^
        temp_observation.hashCode;
  }
}
