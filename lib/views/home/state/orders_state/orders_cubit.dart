import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/models/order_response.dart';
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
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchOrders() async* {
    var user = await storage.getDataStorage("user");
    AppPermission access = AppPermission.values.byName(user["access_level"]);

    if (access == AppPermission.waiter) {
      yield* repository.fetchAllOrdersForWaiters();
    } else if (access == AppPermission.radm ||
        access == AppPermission.employee) {
      yield* repository.fetchOrdersByRestaurantId(user["restaurant"]["id"]);
    } else if (access == AppPermission.cashier) {
      var start = DateTime.now().subtract(const Duration(hours: 24));
      var end = DateTime.now().add(const Duration(hours: 12));
      yield* repository.fetchAllOrdersByInterval(start, end);
    }

    yield* repository.fetchAllOrders();
  }

  void changeStatus({
    required context,
    required List<OrderResponse> items,
  }) async {
    emit(state.copyWith(status: AppStatus.loading));
    var firstOrder = items[0];

    double total =
        items.map((e) => e.value).reduce((value, element) => value + element);
    double paid = items[0].paid;
    final user = await storage.getDataStorage("user");
    final restaurantName = user["restaurant"]["name"];
    AppPermission access = AppPermission.values.byName(user["access_level"]);
    var status = OrderStatus.values.byName(firstOrder.status);

    var allStatus =
        items.map((e) => OrderStatus.values.byName(e.status)).toList();

    var isCashierAllowedByStatus =
        items.every((key) => key.status == OrderStatus.done.name);

    bool isCashierAllowed =
        access == AppPermission.cashier && isCashierAllowedByStatus ||
            firstOrder.isDelivery;

    List<String> ids = items.map((e) => e.id).toList();

    var nextStatus = getNextStatus(status, firstOrder.isDelivery);

    if ((access == AppPermission.employee ||
            access == AppPermission.waiter ||
            access == AppPermission.sadm ||
            access == AppPermission.radm ||
            isCashierAllowed) &&
        nextStatus != null &&
        nextStatus != OrderStatus.canceled) {
      bool confimationOrderPayment =
          allStatus.contains(OrderStatus.in_delivery) ||
              allStatus.contains(OrderStatus.waiting_payment);
      dynamic didPayment;

      if (confimationOrderPayment) {
        didPayment = await AppModal().showModalBottomSheet(
            context: context,
            dimissible: false,
            content: ConfirmOrderModal(
                value: total - paid, method: firstOrder.paymentMethod));

        if (didPayment != null && didPayment != firstOrder.paymentMethod) {
          await repository.updateMultiplePaymentMethod(ids, didPayment);
        }
      }
      if (didPayment != null || !confimationOrderPayment) {
        switch (status) {
          case OrderStatus.waiting_payment:
            await repository.addWaiterToAllOrderPayment('${user["name"]}', ids);
            break;

          case OrderStatus.order_in_progress:
            if (!firstOrder.isDelivery) {
              final notification = AppNotification();
              await notification.sendToWaiters(code: "#${firstOrder.table}");
            }
            break;
          case OrderStatus.done:
            if (access == AppPermission.waiter) {
              await repository.addWaiterToAllOrderDelivered(
                  '${user["name"]}', ids);
            }
            break;

          default:
        }

        if (nextStatus == OrderStatus.delivered) {
          await addOrderToReport(
              orders: items,
              restaurant: restaurantName,
              datetime: firstOrder.created_at);
        }
        await repository.updateManyStatus(ids, nextStatus);
        emit(state.copyWith(status: AppStatus.loaded));
      }
    }
    Timer(const Duration(milliseconds: 500), () {
      emit(state.copyWith(status: AppStatus.loaded));
    });
  }

  void cancelOrder(ids) async {
    await repository.updateStatus(ids, OrderStatus.canceled);
  }

  OrderStatus? getNextStatus(OrderStatus currentStatus, bool isDelivery) {
    var nextStatus = OrderStatus.values[currentStatus.index + 1];

    if (nextStatus == OrderStatus.invalid) return null;

    if (!isDelivery && currentStatus == OrderStatus.done) {
      nextStatus = OrderStatus.delivered;
    }

    return nextStatus;
  }

  Future<void> addOrderToReport(
      {required List<OrderResponse> orders,
      required String restaurant,
      required datetime}) async {
    final dataStorage = await storage.getDataStorage("user");

    double total =
        orders.map((e) => e.value).reduce((value, element) => value + element);

    String method = orders[0].paymentMethod;

    var finance = FinanceApiServices();

    var submitItems = orders.map((e) {
      return e.items.map((order) {
        double value = order.optionSelected.value;

        List extrasList = order.extras ?? [];
        double extras = extrasList.isEmpty
            ? 0.0
            : extrasList
                .map((extra) => double.parse(extra["value"].toString()))
                .reduce((value, element) => value + element);

        return {
          "name": order.item.title,
          "extras": extrasList,
          "value": value,
          "extrasTotal": extras,
          "amount": order.amount,
        };
      });
    }).toList();

    String time = DateFormat("HH:mm").format(datetime);

    for (int i = 0; i < orders.length; i++) {
      var data = {
        "total": orders[i].value,
        "orders": submitItems[i],
        "time": time,
        "payment": method,
      };
      await finance.setMonthlyBudgetFirebase(orders[i].restaurant, data,
          orders[i].value, orders[i].restaurantName);
    }
  }

  void filterOrders(String text) {
    if (text.isNotEmpty) {
      emit(state.copyWith(filter: text));
    }
  }
}
