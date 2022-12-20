import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/models/bank_model.dart';

import 'package:snacks_pro_app/models/item_model.dart';

class FinanceApiServices {
  final http.Client httpClient = http.Client();
  final firebase = FirebaseFirestore.instance;

  Future<List> getBanks() async {
    try {
      var response =
          await httpClient.get(Uri.https("brasilapi.com.br", "api/banks/v1"));
      response.body;
      return List.from(jsonDecode(response.body));
    } catch (e) {
      print(e);
    }

    return [];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSchedule() {
    try {
      return firebase
          .collection("snacks_config")
          .doc("work_time")
          .collection("days")
          .snapshots();
    } catch (e) {
      rethrow;
    }
    // return data;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPrinters(id) {
    try {
      return firebase
          .collection("printers")
          .where("restaurant", isEqualTo: id)
          .snapshots();
    } catch (e) {
      rethrow;
    }
    // return data;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPrinterByGoal(
      String restaurant, String goal) {
    try {
      return firebase
          .collection("printers")
          .where("goal", isEqualTo: goal)
          .where("restaurant", isEqualTo: restaurant)
          .limit(1)
          .get();
    } catch (e) {
      rethrow;
    }
    // return data;
  }

  Future<void> updatePrinter(Map<String, dynamic> data, id) async {
    try {
      return await firebase.collection("printers").doc(id).update(data);
    } catch (e) {
      rethrow;
    }
    // return data;
  }

  Future<void> deletePrinter(String id) async {
    try {
      return await firebase.collection("printers").doc(id).delete();
    } catch (e) {
      rethrow;
    }
    // return data;
  }

  Future addPrinter(data) async {
    try {
      return await firebase.collection("printers").add(data);
    } catch (e) {
      rethrow;
    }
    // return data;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRestaurants() {
    // try {
    return firebase
        .collection("restaurants")
        .snapshots()
        .handleError((onError) => print);

    // return data.docs;
  }

  Future<void> updateTime(int day, Map<String, dynamic> data) {
    // try {
    print(day.toString());
    return firebase
        .collection("snacks_config")
        .doc("work_time")
        .collection("days")
        .doc(day.toString())
        .update(data);

    // return data.docs;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFeedbacks() async {
    // try {
    return await firebase
        .collection("feedbacks")
        .get()
        .catchError((onError) => print);

    // return data.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getRestaurantExpenses() async {
    // try {
    var data = await firebase
        .collection("snacks_config")
        .doc("expenses")
        .collection("all")
        .get()
        .catchError((onError) => print);

    return data.docs;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRestaurantExpensesStream() {
    return firebase
        .collection("snacks_config")
        .doc("expenses")
        .collection("all")
        .snapshots()
        .handleError((onError) => print);
  }

  Future<double> getMonthlyBudget(String restaurant_id) async {
    var now = DateTime.now();
    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";

    try {
      var data = await firebase
          .collection("receipts")
          .doc(restaurant_id)
          .collection("months")
          .doc(month_id)
          // .doc("augut-2022")
          .get();

      var map = data.data();
      if (data.exists) return map?["total"];
    } catch (e) {
      print("error getMontthly: " + e.toString());
    }
    return 0;
  }

  Future<double> getMonthlyBudgetSnacks() async {
    var now = DateTime.now();
    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";

    try {
      var restaurants = await firebase.collection("restaurants").get();
      var data = restaurants.docs
          .map((e) async => await firebase
              .collection("receipts")
              .doc(e.id)
              .collection("months")
              .doc(month_id)
              .get())
          .toList();
      // print(data.reference);
      // if (data.exists) return data.get("total");
    } catch (e) {
      print("error getMontthly: " + e.toString());
    }
    return 0;
  }

  Future<void> setMonthlyBudgetFirebase(
      String restaurant_id, Map<String, dynamic> data, double total) async {
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
    var day_id = "${now.day}";

    var docref = firebase
        .collection("receipts")
        .doc(restaurant_id)
        .collection("months")
        .doc(month_id);
    var snacks = firebase
        .collection("receipts")
        .doc("snacks")
        .collection("months")
        .doc(month_id);

    var dayDocRef = docref.collection("days").doc(day_id);

    await dayDocRef.collection("items").add(data);

    await dayDocRef.set({
      "total": FieldValue.increment(total),
      "length": FieldValue.increment(1)
    }, SetOptions(merge: true));

    await snacks.set({
      "total": FieldValue.increment(total),
      "length": FieldValue.increment(1)
    }, SetOptions(merge: true));

    // print("run transactions");
    await firebase.runTransaction((transaction) async {
      final snapshot = await transaction.get(docref);
      final snacks_snapshot = await transaction.get(snacks);

      if (snapshot.data() == null || snapshot.data()!.isEmpty) {
        transaction.set(docref, {"total": total});
      } else {
        final newTotalValue = snapshot.get("total") + total;
        transaction.update(docref, {"total": newTotalValue});
      }
//snacks total
      if (snacks_snapshot.data() == null || snacks_snapshot.data()!.isEmpty) {
        transaction.set(docref, {"total": total});
      } else {
        final newTotalValue = snacks_snapshot.get("total") + total;
        transaction.update(docref, {"total": newTotalValue});
      }
    }).then(
      (value) => print("Document snapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMonthlyOrders(
      String restaurant_id) async {
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
    // var day_id = "day-${now.day}";
    print(month_id);
    return await firebase
        .collection("receipts")
        .doc(restaurant_id)
        .collection("months")
        .doc(month_id)
        .collection("days")
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDayOrders(
      String restaurant_id, String day) async {
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";

    return await firebase
        .collection("receipts")
        .doc(restaurant_id)
        .collection("months")
        .doc(month_id)
        .collection("days")
        .doc(day)
        .collection("items")
        .get();
  }

  Future<void> saveBankInfo(data, id) async {
    return await firebase.collection("restaurants").doc(id).update(data);
  }

  Future saveExpense(data) async {
    return await firebase
        .collection("snacks_config")
        .doc("expenses")
        .collection("all")
        .add(data);
  }

  Future<DocumentReference<Map<String, dynamic>>> saveRestaurant(data) async {
    return await firebase.collection("restaurants").add(data);
  }

  Future<void> deleteExpense(id) async {
    return await firebase
        .collection("snacks_config")
        .doc("expenses")
        .collection("all")
        .doc(id)
        .delete();
  }

  Future<void> deleteRestaurant(id) async {
    return await firebase.collection("restaurants").doc(id).delete();
  }

  Future<void> updateRestaurant(data, doc) async {
    return await firebase.collection("restaurants").doc(doc).update(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBankInformations(
      String id) async {
    return firebase.collection("restaurants").doc(id).get();
    // return Future.delayed(Duration(milliseconds: 600), () {
    //   return BankModel.fromMap({
    //     "id": "002",
    //     "owner": "Jose Ricardo Silva",
    //     "bank": "Banco Inter SA",
    //     "account": "999999-99",
    //     "agency": "0001",
    //   });
    // });
  }
}
