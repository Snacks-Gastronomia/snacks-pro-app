import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_consume.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';

class NewStockService {
  final firebase = FirebaseFirestore.instance;
  final storage = AppStorage();

  Future<String> getId() async {
    var data = await storage.getDataStorage("user");
    return data["restaurant"]["id"];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamStock() async* {
    try {
      String restaurantId = await getId();
      yield* firebase
          .collection('stock')
          .doc(restaurantId)
          .collection('items')
          .snapshots();
    } catch (e) {
      print('Erro ao obter dados do Firestore: $e');
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLossesCollection(
      {required String data, required String item}) async {
    try {
      String restaurantId = await getId();
      QuerySnapshot<Map<String, dynamic>> lossesSnapshot =
          await FirebaseFirestore.instance
              .collection('stock')
              .doc(restaurantId)
              .collection('losses')
              .get();

      return lossesSnapshot.docs;
    } catch (e) {
      print('Erro ao obter dados do Firestore: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getItemLossesCollection({required String item}) async {
    try {
      String restaurantId = await getId();
      QuerySnapshot<Map<String, dynamic>> lossesSnapshot =
          await FirebaseFirestore.instance
              .collection('stock')
              .doc(restaurantId)
              .collection('losses')
              .where('title', isEqualTo: item)
              .get();

      return lossesSnapshot.docs;
    } catch (e) {
      print('Erro ao obter dados do Firestore: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getDataLossesCollection(
          {required int mounth, required String item}) async {
    try {
      String restaurantId = await getId();
      QuerySnapshot<Map<String, dynamic>> lossesSnapshot =
          await FirebaseFirestore.instance
              .collection('stock')
              .doc(restaurantId)
              .collection('losses')
              .where('dateTime',
                  isGreaterThanOrEqualTo: DateTime(2023, mounth, 1))
              .where('dateTime', isLessThan: DateTime(2023, (mounth + 1), 1))
              .get();

      return lossesSnapshot.docs;
    } catch (e) {
      print('Erro ao obter dados do Firestore: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<void> addItemToStock(ItemStock item) async {
    String restaurantId = await getId();
    await firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('items')
        .doc(item.title)
        .set(item.toMap());
  }

  Future<void> updateItemStock(
      {required ItemStock item,
      required int amount,
      required int value,
      required DateTime dateTime}) async {
    String restaurantId = await getId();
    await firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('items')
        .doc(item.title)
        .update({
      'amount': FieldValue.increment(amount),
      'value': FieldValue.increment(value),
      'dateTime': dateTime,
    });
  }

  Future<void> addItem({required ItemConsume item}) async {
    String restaurantId = await getId();
    await firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('items')
        .doc(item.title)
        .set(item.toMap());
  }

  Future<void> addLossesItemStock(
      {required ItemStock item,
      required int losses,
      required String dateTime,
      required String description}) async {
    String restaurantId = await getId();
    await firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('items')
        .doc(item.title)
        .update({
      'losses': FieldValue.increment(losses),
    });

    Map<String, dynamic> lossesMap = {
      'title': item.title,
      'losses': losses,
      'dateTime': DateFormat('dd/MM/yyy').parse(dateTime),
      'description': description,
    };

    await firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('losses')
        .doc()
        .set(lossesMap);
  }

  Future<void> addConsumeItemStock(ItemStock item, int consume) async {
    await firebase.collection('stock').doc(item.title).update({
      'consume': FieldValue.increment(consume),
    });
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
