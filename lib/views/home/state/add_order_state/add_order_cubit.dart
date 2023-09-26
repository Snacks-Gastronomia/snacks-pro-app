import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void removeItem(index, orders) {
    subtotal -= orders[index].item.value;
    updateTotal();
    orders.removeAt(index);
  }

  void incrementAmount(index, List<OrderModel> orders) {
    var amount = orders[index].amount;
    amount == null ? amount = 1 : amount += 1;
    orders[index].amount = amount;

    console.log('$amount');
  }

  void decrementAmount(index, List<OrderModel> orders) {
    var amount = orders[index].amount;
    amount == null ? amount = 1 : amount -= 1;
    orders[index].amount = amount;
    console.log('$amount');
  }
}
