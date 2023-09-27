import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/models/order_response.dart';

import '../../../../models/item_model.dart';
import '../../../../models/order_model.dart';
import 'add_order_state.dart';
import 'dart:developer' as console;

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit() : super(AddOrderState.inital());
  double subtotal = 0;
  double delivery = 7;
  double total = 0;

  void handleCheckboxValue(bool value) {
    value ? delivery = 7 : delivery = 0;
    updateTotal();
  }

  void updateTotal() {
    total = subtotal + delivery;
  }

  void removeItem(index, orders, amount) {
    subtotal -= (orders[index].item.value * amount);
    updateTotal();
    orders.removeAt(index);
  }

  void incrementAmount(index, List<ItemResponse> orders) {
    subtotal += orders[index].item.value;
    var amount = orders[index].amount;
    amount += 1;
    orders[index].amount = amount;

    updateTotal();
  }

  void decrementAmount(index, List<ItemResponse> orders) {
    var amount = orders[index].amount;
    if (amount > 1) {
      amount -= 1;
      subtotal -= orders[index].item.value;
    }

    orders[index].amount = amount;

    updateTotal();
  }

  Future<void> submitOrder(
      orders, restaurantName, restaurantId, total, datetime) async {
    final firestore = FirebaseFirestore.instance;
    OrderResponse order = OrderResponse(
      code: "pedido-manual",
      needChange: false,
      restaurant: restaurantId,
      createdAt: datetime,
      restaurantName: restaurantName,
      isDelivery: true,
      waiterPayment: "pedido-manual",
      id: "pedido-manual",
      waiterDelivery: "pedido-manual",
      partCode: "pedido-manual",
      items: orders,
      value: 0,
      paymentMethod: '',
      status: "Delivered",
      userUid: "pedido-manual",
    );
    try {
      await firestore.collection("orders").add(orders);
    } catch (e) {
      print("e");
    }
  }
}
