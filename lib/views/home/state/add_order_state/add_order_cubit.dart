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

  void removeItem(OrderResponse orders, amount) {
    subtotal -= (orders.items[0].item.value * amount);
    updateTotal();
    orders.items.removeAt(0);
  }

  void incrementAmount(OrderResponse orders) {
    subtotal += orders.items[0].item.value;
    var amount = orders.items[0].amount;
    amount += 1;
    orders.items[0].amount = amount;

    updateTotal();
  }

  void decrementAmount(OrderResponse orders) {
    var amount = orders.items[0].amount;
    if (amount > 1) {
      amount -= 1;
      subtotal -= orders.items[0].item.value;
    }

    orders.items[0].amount = amount;

    updateTotal();
  }
}
