import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/consume_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_consume.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';

class NewStockService {
  final firebase = FirebaseFirestore.instance;
  final storage = AppStorage();

  Future<String> getId() async {
    var data = await storage.getDataStorage("user");
    return data["restaurant"]["id"];
  }

  var refItemStock = FirebaseFirestore.instance.collection('stock');

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
      return [];
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
      return [];
    }
  }

  Stream<List> getItemConsumeStream({required String item}) async* {
    try {
      String restaurantId = await getId();

      yield* firebase
          .collection('stock')
          .doc(restaurantId)
          .collection('items')
          .doc(item)
          .snapshots()
          .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        List itemList = snapshot.data()?['items'] ?? [];
        return itemList;
      });
    } catch (e) {
      print('Erro ao obter dados do Firestore: $e');
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
      return [];
    }
  }

  Future<void> deleteItem({
    required ItemConsume itemConsume,
    required String stockItemId,
    required int index,
  }) async {
    try {
      String restaurantId = await getId();

      DocumentReference<Map<String, dynamic>> stockDocRef = FirebaseFirestore
          .instance
          .collection('stock')
          .doc(restaurantId)
          .collection('items')
          .doc(stockItemId);

      DocumentSnapshot<Map<String, dynamic>> stockSnapshot =
          await stockDocRef.get();
      List<dynamic> currentItems = stockSnapshot.data()?['items'] ?? [];

      if (index >= 0 && index < currentItems.length) {
        currentItems.removeAt(index);

        await stockDocRef.update({
          'items': currentItems,
        });
      } else {
        print('Índice inválido para exclusão do stock.');
      }

      QuerySnapshot<Map<String, dynamic>> menuQuery = await FirebaseFirestore
          .instance
          .collection('menu')
          .where('title', isEqualTo: itemConsume.title)
          .limit(1)
          .get();

      DocumentReference<Map<String, dynamic>> menuDocRef =
          menuQuery.docs.first.reference;
      List<dynamic> menuIngredients =
          menuQuery.docs.first.data()['ingredients'] ?? [];

      menuIngredients.remove(stockItemId);

      await menuDocRef.set({
        'ingredients': menuIngredients,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erro ao excluir item: $e');
      throw e;
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

  Future<void> addItem(
      {required ItemConsume itemConsume, required ItemStock itemStock}) async {
    String restaurantId = await getId();
    await firebase
        .collection('stock')
        .doc(restaurantId)
        .collection('items')
        .doc(itemStock.title)
        .set({
      'items': FieldValue.arrayUnion([itemConsume.toMap()]),
    }, SetOptions(merge: true));

    QuerySnapshot<Map<String, dynamic>> ref = await firebase
        .collection('menu')
        .where('title', isEqualTo: itemConsume.title)
        .limit(1)
        .get();

    var id = ref.docs.first.data()['id'];

    await firebase.collection('menu').doc(id).set({
      'ingredients': FieldValue.arrayUnion([itemStock.title]),
    }, SetOptions(merge: true));
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
    String restaurantId = await getId();
    await refItemStock
        .doc(restaurantId)
        .collection('items')
        .doc(item.title)
        .update({
      'consume': consume,
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getItemsMenu() async* {
    try {
      String restaurantId = await getId();
      var ref = firebase
          .collection("menu")
          .where("restaurant_id", isEqualTo: restaurantId);

      yield* ref.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getOrders() async {
    try {
      String restaurantId = await getId();
      QuerySnapshot<Map<String, dynamic>> ref = await firebase
          .collection('orders')
          .orderBy('created_at', descending: true)
          .where('restaurant', isEqualTo: restaurantId)
          .limit(500)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in ref.docs) {
        final data = doc.data();
        // print('Documento ID: ${doc.id}');
        // print('Dados: $data');
      }

      return ref.docs.toList();
    } catch (e) {
      debugPrint('Erro: $e');
      rethrow;
    }
  }

  Future updateConsume(ItemStock itemStock) async {
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> order =
          await getOrders();
      List<OrderResponse> res =
          order.map((e) => OrderResponse.fromFirebase(e)).toList();

      List<OrderResponse> filterList = res
          .where((element) => element.items.any(
              (element) => element.item.ingredients!.contains(itemStock.title)))
          .toList();

      List test = filterList.map((e) => e.items.first.item.title).toList();

      List<Map> myConsume = filterList
          .map((e) => {
                'amount': e.items.map((e) => e.amount).first,
                'ingredients':
                    e.items.map((e) => e.item.ingredients!.first).first,
                'consume': itemStock.items!
                    .where((element) => test.contains(element.title))
                    .map((e) => e.consume)
                    .first,
                'month': DateFormat('MMM').format(e.created_at)
              })
          .toList();

      print(myConsume);

      String restaurantId = await getId();
      for (Map consume in myConsume) {
        String month = consume['month'];

        DocumentReference docRef = firebase
            .collection('stock')
            .doc(restaurantId)
            .collection('consume')
            .doc(month);
        var newValue = (consume['consume'] * consume['amount']);
        await docRef.set({
          "consume": newValue,
          "ingredients": consume['ingredients'],
          "month": month
        });
      }

      return myConsume;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getConsume(ItemStock itemStock) async {
    try {
      String month = DateFormat('MMM').format(DateTime.now());
      String restaurantId = await getId();
      var res = await firebase
          .collection('stock')
          .doc(restaurantId)
          .collection('consume')
          .get();

      var data = res.docs.map((e) => e.data()).toList();
      var filterData =
          data.where((element) => element['ingredients'] == itemStock.title);
      List<ConsumeStock> consumeList =
          filterData.map((e) => ConsumeStock.fromMap(e)).toList();

      int totalConsume = 0;
      for (final consumeStock in consumeList) {
        totalConsume += consumeStock.consume;
      }

      addConsumeItemStock(itemStock, totalConsume);

      return totalConsume;
    } catch (e) {
      rethrow;
    }
  }
}
