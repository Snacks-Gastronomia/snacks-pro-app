// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/firebase/database.dart';

class StockItem {
  final String? id;
  final String title;
  final int amount;
  final double unique_volume;
  final String unit;
  StockItem({
    this.id,
    required this.title,
    required this.amount,
    required this.unique_volume,
    required this.unit,
  });
}

class StockApiServices {
  final database = FirebaseFirestore.instance;
  final http.Client httpClient = http.Client();

  Stream<QuerySnapshot<Map<String, dynamic>>> getStock(String? restaurant_id,
      {int limit = 5}) {
    try {
      // var ref = database.collection("stock").doc(restaurant_id).snapshots();
      // .limit(limit);
      // if (document != null) {
      //   return ref.startAfterDocument(document).snapshots();
      // }
      return database
          .collection("restaurants")
          .doc(restaurant_id)
          .collection("stock")
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStockConsumed(
      String? restaurant_id,
      {int limit = 5}) {
    try {
      // var ref = database.collection("stock").doc(restaurant_id).snapshots();
      // .limit(limit);
      // if (document != null) {
      //   return ref.startAfterDocument(document).snapshots();
      // }
      return database
          .collection("restaurants")
          .doc(restaurant_id)
          .collection("stock_consumed")
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createStockItem(restaurant_id, data) async {
    try {
      await database
          .collection("restaurants")
          .doc(restaurant_id)
          .collection("stock")
          .add(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateStockItem(restaurant_id, doc, data) async {
    try {
      await database
          .collection("restaurants")
          .doc(restaurant_id)
          .collection("stock")
          .doc(doc)
          .update(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateStock(restaurant_id, doc, data) async {
    try {
      await database
          .collection("restaurants")
          .doc(restaurant_id)
          .collection("stock")
          .doc(doc)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }
}
