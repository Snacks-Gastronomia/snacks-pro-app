import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/services/orders_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/repository/finance_repository.dart';
import 'package:snacks_pro_app/views/home/repository/orders_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final repository = FinanceRepository(services: FinanceApiServices());
  final storage = AppStorage();
  OrdersCubit() : super(OrdersState.initial());

  Future<QuerySnapshot<Map<String, dynamic>>> fetchDaily(day) async {
    var id = await getRestaurantId();
    return await repository.getDayOrders(id, day);
  }

  getRestaurantId() async {
    var user = await storage.getDataStorage("user");
    return user["restaurant"]["id"];
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchMonthly() async {
    emit(state.copyWith(status: AppStatus.loading));
    var id = await getRestaurantId();

    var response = await repository.getMonthlyOrders(id);
    double total_value = 0;
    int orders_amount = 0;

    for (var e in response.docs) {
      print(e.data());
      orders_amount += e.data()["length"] as int;
      total_value += e.data()["total"];
    }
    emit(state.copyWith(
      status: AppStatus.loaded,
      total_orders_monthly: orders_amount,
      budget_monthly: total_value,
      // orders_monthly: response.toList()
    ));

    return response;
  }
}
