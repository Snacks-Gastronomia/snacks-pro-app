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

  Future<List<Map<String, dynamic>>?> getRestaurantsProfits() async {
    try {
      var restaurants = await firebase.collection("restaurants").get();
      var now = DateTime.now();
      var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
      const snacksID = "clvyfPUDl2nZhVUWQT8n";

      List<Map<String, dynamic>> list = [];
      for (var element in restaurants.docs) {
        if (element.id != snacksID) {
          var res = await firebase
              .collection("receipts")
              .doc(element.id)
              .collection("months")
              .doc(month_id)
              .get();

          var data = {
            "id": element.id,
            "name": element.data()["name"],
            "total": res.data()?["total"] ?? 0
          };

          list.add(data);
        }
      }

      return list;
    } catch (e) {
      print(e);
    }
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

  Future<int> getCountRestaunts() async {
    try {
      AggregateQuerySnapshot snapshot =
          await firebase.collection("restaurants").count().get();

      return snapshot.count - 1;
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeatures() {
    // try {
    return firebase
        .collection("snacks_config")
        .doc("features")
        .collection("all")
        .snapshots();

    // return data.docs;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFeatureByName(
      {required String name}) {
    // try {
    return firebase
        .collection("snacks_config")
        .doc("features")
        .collection("all")
        .where("name", isEqualTo: name)
        .get();

    // return data.docs;
  }

  Future<void> updateFeature({required String doc, required update}) {
    // try {
    return firebase
        .collection("snacks_config")
        .doc("features")
        .collection("all")
        .doc(doc)
        .update(update);

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

  Future<void> updateFeatureValue(String docID, bool value) {
    Map<String, dynamic> data = {"active": value};
    // try {
    return firebase
        .collection("snacks_config")
        .doc("features")
        .collection("all")
        .doc(docID)
        .set(data, SetOptions(merge: true));

    // return data.docs;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFeedbacks() async {
    // try {
    return await firebase
        .collection("feedbacks")
        .orderBy("created_at", descending: true)
        .get()
        .catchError((onError) => print);

    // return data.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getExpenses() async {
    // try {
    var data = await firebase
        .collection("snacks_config")
        .doc("expenses")
        .collection("all")
        .get()
        .catchError((onError) => print);

    return data.docs;
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getExpensesStream(doc) {
  //   // try {
  //   return firebase
  //       .collection("restaurants")
  //       .doc(doc)
  //       .collection("expenses")
  //       .snapshots();
  // }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getRestaurantExpenses(doc) async {
    // try {
    var data = await firebase
        .collection("restaurants")
        .doc(doc)
        .collection("expenses")
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

  // Future getReceiptsByRestaurant() async{
  //   return await firebase.collection("receipts");
  // }

  Future<void> setMonthlyBudgetFirebase(String restaurant_id,
      Map<String, dynamic> data, double total, String name) async {
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
    var day_id = DateFormat("dd").format(now);

    var restRef = firebase.collection("receipts").doc(restaurant_id);

    await restRef.set({"name": name});

    var docref = restRef.collection("months").doc(month_id);
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

    await docref.set({
      "total": FieldValue.increment(total),
    }, SetOptions(merge: true));

    await snacks.set({
      "total": FieldValue.increment(total),
      "length": FieldValue.increment(1)
    }, SetOptions(merge: true));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMonthlyOrders(
      String restaurant_id, String month) async {
    var now = DateTime.now();
    var monthFormat = DateFormat.MMMM().format(now);
    var month_id =
        month.isEmpty ? "$monthFormat-${now.year}" : "$month-${now.year}";

    return await firebase
        .collection("receipts")
        .doc(restaurant_id)
        .collection("months")
        .doc(month_id)
        .collection("days")
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDayOrders(
      String restaurant_id, String day, DateTime month) async {
    var month_id = "${DateFormat.MMMM().format(month)}-${month.year}";
    print(month);
    return await firebase
        .collection("receipts")
        .doc(restaurant_id)
        .collection("months")
        .doc(month_id)
        .collection("days")
        .doc(day)
        .collection("items")
        .orderBy("time")
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

  Future saveRestExpense(data, id) async {
    return await firebase
        .collection("restaurants")
        .doc(id)
        .collection("expenses")
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

  Future<void> deleteRestaurantExpense(id, restaurant_id) async {
    return await firebase
        .collection("restaurants")
        .doc(restaurant_id)
        .collection("expenses")
        .doc(id)
        .delete();
  }

  Future<void> deleteRestaurant(rid, owner_id) async {
    await firebase.collection("employees").doc(owner_id).delete();

    var values = await firebase
        .collection("menu")
        .where("restaurant_id", isEqualTo: rid)
        .get();

    for (var element in values.docs) {
      await element.reference.delete();
    }

    return await firebase.collection("restaurants").doc(rid).delete();
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
