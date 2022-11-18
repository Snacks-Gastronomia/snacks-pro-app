import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/home/repository/orders_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final repository = OrdersRepository();
  final auth = FirebaseAuth.instance;
  final storage = AppStorage();

  CartCubit() : super(CartState.initial());

  void addToCart(Order newOrder) {
    // print(newOrder);

    // newOrder.observations = state.temp_observation;

    if (hasItem(newOrder.item.id!)) {
      var ord = getOrderByItemId(newOrder.item.id!);
      if (ord != null) {
        ord.copyWith(
            amount: newOrder.amount, observations: newOrder.observations);
      }
    }

    final newCart = [...state.cart, newOrder];

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
    emit(state.copyWith(temp_observation: ""));
    print(state);
  }

  updateItemFromCart(Order order) {
    final newCart = state.cart.map((item) {
      if (item.item.id == order.item.id) {
        return item.copyWith(
            amount: order.amount,
            item: order.item,
            observations: order.observations);
      }
      return item;
    }).toList();

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
  }

  bool hasItem(String id) {
    var item = state.cart.where((element) => element.item.id == id);
    return item.isNotEmpty;
  }

  Order? getOrderByItemId(String id) {
    return hasItem(id)
        ? state.cart.singleWhere((el) => el.item.id == id)
        : null;
  }

  void incrementItem(String id) {
    final newCart = state.cart.map((item) {
      if (item.item.id == id) {
        return item.copyWith(amount: (item.amount + 1));
      }
      return item;
    }).toList();

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
    print(state);
  }

  void decrementItem(String id) {
    final newCart = state.cart.map((item) {
      if (item.item.id == id) {
        if (item.amount > 1) return item.copyWith(amount: (item.amount - 1));
      }
      return item;
    }).toList();

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
    print(state);
    print(state.total);
  }

  void removeToCart(Order order) {
    final newCart = state.cart;
    newCart.removeWhere((element) => element.item.id == order.item.id);

    emit(state.copyWith(cart: newCart));

    updateTotalValue();
    print(state);
  }

  void updateTotalValue() {
    double total = 0;
    for (var element in state.cart) {
      total += element.item.value * element.amount;
    }
    print(total);
    emit(state.copyWith(total: total));
  }

  // void makeOrder(String method) async {
  //   final dataStorage = await storage.getDataStorage("user");

  //   bool isDelivery = !auth.currentUser!.isAnonymous;
  //   var status = method == "Cartão Snacks" || isDelivery
  //       ? OrderStatus.order_in_progress.name
  //       : OrderStatus.waiting_payment.name;

  //   final now = DateTime.now();
  //   DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  //   Map<String, dynamic> data = {
  //     // "orders":
  //     //     FieldValue.arrayUnion(state.cart.map((e) => e.toMap()).toList()),
  //     "user_uid": auth.currentUser!.uid,
  //     "payment_method": method,
  //     "value": state.total,
  //     "isDelivery": isDelivery,
  //     "status": status,
  //     "created_at": DateTime.now(),
  //   };
  //   // data.addAll(isDelivery
  //   //     ? {"address": dataStorage["address"]}
  //   //     : {"table": dataStorage["table"]});

  //   var response = await repository.createOrder(data);

  //   var items = state.cart.map((e) => e.toMap()).toList();
  //   await repository.createItemstoOrder(items, response);
  //   clearCart();
  // }

  void clearCart() {
    emit(state.copyWith(cart: []));
  }

  void changeStatusBackward(doc_id, List<Map<String, dynamic>> items,
      String payment_method, OrderStatus current) async {}

  void changeStatusFoward(doc_id, List<dynamic> items, String payment_method,
      String current, dynamic datetime) async {
    var finance = FinanceApiServices();
    final dataStorage = await storage.getDataStorage("user");

    var current_index =
        OrderStatus.values.firstWhere((e) => e.name == current).index;
    var status = OrderStatus.values[current_index + 1];

    print(status);
    // List<String> ids = items.map<String>((e) => e["id"]).toList();
    await repository.updateStatus(doc_id, status);

    if (status == OrderStatus.done) {
      double total = 0;
      var submitItems = items.map((e) {
        total += e["item"]["value"];
        return {
          "name": e["item"]["title"],
          "amount": e["amount"],
          "payment": payment_method,
        };
      }).toList();
      var data = {"total": total, "orders": submitItems, "datetime": datetime};
      await finance.setMonthlyBudgetFirebase(
          dataStorage["restaurant"]["id"], data, total);
    }
  }
}
