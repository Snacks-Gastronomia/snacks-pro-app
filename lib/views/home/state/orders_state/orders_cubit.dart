import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/services/firebase/notifications.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/home/repository/orders_repository.dart';
import 'package:snacks_pro_app/views/home/widgets/modals/confirm_order.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final repository = OrdersRepository();
  final auth = FirebaseAuth.instance;
  final storage = AppStorage();

  OrdersCubit() : super(OrdersState.initial());

  double getTotal(List<dynamic> items) {
    double total = 0;

    for (var element in items) {
      var order = OrderModel.fromMap(element);

      double extras = order.extras.isEmpty
          ? 0.0
          : order.extras
              .map((extra) => double.parse(extra["value"].toString()))
              .reduce((value, element) => value + element);

      total += order.amount *
          double.parse(order.option_selected["value"].toString());
      total += extras;
    }
    return total;
  }

  void changeStatusBackward(doc_id, List<Map<String, dynamic>> items,
      String payment_method, OrderStatus current) async {}

  void changeStatus(
      context,
      String? table,
      doc_id,
      List<dynamic> items,
      String payment_method,
      String current,
      dynamic datetime,
      bool isDelivery) async {
    double total = getTotal(items);
    final user = await storage.getDataStorage("user");
    var current_index = getStatusIndex(current);
    final restaurant_name = user["restaurant"]["name"];

    if (user["access_level"] == AppPermission.employee.name &&
            current != OrderStatus.done.name ||
        user["access_level"] == AppPermission.cashier.name &&
            current_index >= 3 &&
            isDelivery ||
        user["access_level"] == AppPermission.waiter.name &&
            (current_index == 0 || current_index == 3)) {
      if (current_index == 0) {
        repository.addWaiterToOrderPayment('${user["name"]}', doc_id);
      }
      //done
      if (current_index == 3 &&
          user["access_level"] == AppPermission.waiter.name &&
          isDelivery == false) {
        repository.addWaiterToOrderDelivered('${user["name"]}', doc_id);
      }

      if (getStatusObject(current) == OrderStatus.in_delivery ||
          getStatusObject(current) == OrderStatus.waiting_payment) {
        double extras = items.map((e) {
          var ex = List.from(e["extras"]);

          return ex.isNotEmpty
              ? ex
                  .map((extra) => double.parse(extra["value"]))
                  .reduce((value, element) => value + element)
              : 0.0;
        }).reduce((value, element) => value + element);

        var res = await AppModal().showModalBottomSheet(
            context: context,
            dimissible: false,
            content: ConfirmOrderModal(value: total, method: payment_method));

        if (res != null) {
          if (res != payment_method) {
            repository.updatePaymentMethod(doc_id, res);
          }
          changeStatusFoward(total, doc_id, items, payment_method, current,
              datetime, restaurant_name);
        }
      } else {
        if (!isDelivery && current_index == 3) {
          await repository.updateStatus(doc_id, OrderStatus.delivered);
        } else {
          changeStatusFoward(total, doc_id, items, payment_method, current,
              datetime, restaurant_name);
        }
      }
    } else if (user["access_level"] == AppPermission.employee.name) {
      final notification = AppNotification();
      await notification.sendToWaiters(code: "#$table");
    }
  }

  getStatusIndex(String status) {
    return getStatusObject(status).index;
  }

  OrderStatus getStatusObject(String status) {
    return OrderStatus.values.firstWhere((e) => e.name == status);
  }

  void cancelOrder(docId) async {
    await repository.updateStatus(docId, OrderStatus.canceled);
  }

  changeStatusFoward(
      double total,
      doc_id,
      List<dynamic> items,
      String payment_method,
      String current,
      dynamic datetime,
      restaurant_name) async {
    var current_index = getStatusIndex(current);
    var status = OrderStatus.values[current_index + 1];

    if (status == OrderStatus.invalid) return;

    var finance = FinanceApiServices();
    final dataStorage = await storage.getDataStorage("user");

    await repository.updateStatus(doc_id, status);

    if (status == OrderStatus.done) {
      var submitItems = items.map((e) {
        double value = double.parse(e["option_selected"]["value"].toString());

        List extrasList = e["extras"] ?? [];
        double extras = extrasList.isEmpty
            ? 0.0
            : extrasList
                .map((extra) => double.parse(extra["value"].toString()))
                .reduce((value, element) => value + element);

        return {
          "name": e["item"]["title"],
          "extras": extrasList,
          "value": value,
          "extrasTotal": extras,
          "amount": e["amount"],
        };
      }).toList();

      String time = DateFormat("HH:mm").format(datetime.toDate());
      var data = {
        "total": total,
        "orders": submitItems,
        "time": time,
        "payment": payment_method,
      };

      await finance.setMonthlyBudgetFirebase(
          dataStorage["restaurant"]["id"], data, total, restaurant_name);
    }
  }
}
