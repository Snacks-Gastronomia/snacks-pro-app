import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/services/receipts_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/repository/finance_repository.dart';

part 'finance_orders_state.dart';

class FinanceOrdersCubit extends Cubit<FinanceOrdersState> {
  final repository = FinanceRepository(services: FinanceApiServices());
  final service = ReceiptsService();
  final storage = AppStorage();

  FinanceOrdersCubit() : super(FinanceOrdersState.initial()) {
    fetchReceipts(null, state.interval_start, state.interval_end);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchDaily(day, month,
      {String restaurant_id = ""}) async {
    var id = "";
    if (restaurant_id.isEmpty) {
      id = await getRestaurantId();
    } else {
      id = restaurant_id;
    }
    return await repository.getDayOrders(id, day, month);
  }

  getRestaurantId() async {
    var user = await storage.getDataStorage("user");
    return user["restaurant"]["id"];
  }

  void changeStartInterval(DateTime value) {
    emit(state.copyWith(interval_start: value));
  }

  void changeEndInterval(DateTime value) {
    emit(state.copyWith(interval_end: value));
  }

  fetchReceipts(String? restaurant_id, DateTime start, DateTime end) async {
    print("documents");
    emit(state.copyWith(status: AppStatus.loading));

    var id = restaurant_id ??= await getRestaurantId();

    var response = await service.getReceiptsByInterval(id, start, end);

    var documents =
        response.docs.map((doc) => OrderResponse.fromFirebase(doc)).toList();

    var orders = state.filter == "Todos os itens"
        ? documents
        : documents
            .where((item) =>
                item.items.any((item) => item.item.title == state.filter))
            .toList();

    print(documents);
    emit(state.copyWith(
        orders: orders,
        interval_start: start,
        interval_end: end,
        status: AppStatus.loaded));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchMonthly(
      {String restaurant_id = "", String month = ""}) async {
    emit(state.copyWith(status: AppStatus.loading));
    var id = "";
    // var month = "";
    if (restaurant_id.isEmpty) {
      id = await getRestaurantId();
    } else {
      id = restaurant_id;
    }

    print(restaurant_id);
    var response = await repository.getMonthlyOrders(id, month);
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

  Future<List<String>> getItemsByRestaurantId() async {
    var restaurantId = await getRestaurantId();
    try {
      CollectionReference menuCollection =
          FirebaseFirestore.instance.collection('menu');
      QuerySnapshot querySnapshot = await menuCollection
          .where('restaurant_id', isEqualTo: restaurantId)
          .get();

      List<String> items = [];
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        items.add(data['title']);
      });

      return items;
    } catch (error) {
      rethrow;
    }
  }

  void filterItems(String itemTitle) async {
    print('Filtering items with: $itemTitle');
    var id = await getRestaurantId();
    emit(state.copyWith(filter: itemTitle, status: AppStatus.loading));
    fetchReceipts(id, state.interval_start, state.interval_end);
  }
}
