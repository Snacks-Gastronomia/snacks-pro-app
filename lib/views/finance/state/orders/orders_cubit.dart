import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_pro_app/services/orders_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/home/repository/orders_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final repository = OrdersRepository();
  OrdersCubit() : super(OrdersState.initial()) {
    fetchMonthly();
  }

  fetchMonthly() async {
    emit(state.copyWith(status: AppStatus.loading));
    // var response = await repository.fetchOrdersByMonth(5, "restaurant_id");
    // double total = 0;
    // print(response);
    // for (var e in response) {
    //   total += e["amount"];
    // }
    // emit(state.copyWith(
    //     status: AppStatus.loaded,
    //     total_orders_monthly: response.length,
    //     budget_monthly: total,
    //     orders_monthly: response.toList()));
    // print(total);
  }
}
