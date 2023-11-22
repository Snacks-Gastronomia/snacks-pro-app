import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';

class NewStockService {
  final firebase = FirebaseFirestore.instance;
  final storage = AppStorage();

  Future<String> getId() async {
    var data = await storage.getDataStorage("user");
    return data["restaurant"]["id"];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamStock() async* {
    String restaurantId = await getId();
    yield* firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('items')
        .snapshots();
  }

  Future<void> addItemToStock(ItemStock item) async {
    String restaurantId = await getId();
    await firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('items')
        .add(item.toMap());
  }

  void printItemStock(ItemStock item) {
    debugPrint(item.toMap().toString());
  }

  bool validateItem(ItemStock item) {
    if (item.title != '' &&
        item.amount != 0 &&
        item.document != 0 &&
        item.description != '') {
      return true;
    } else {
      return false;
    }
  }
}
