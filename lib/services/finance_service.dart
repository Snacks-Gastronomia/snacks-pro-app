import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/models/bank_model.dart';

import 'package:snacks_pro_app/models/item_model.dart';

class FinanceApiServices {
  final http.Client httpClient = http.Client();
  final firebase = FirebaseFirestore.instance;
  Future<int> getOrdersCount(String restaurant_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return 257;
    });
  }

  Future<int> getEmployeesCount(String restaurant_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return 5;
    });
  }

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

  Future<double> getMonthlyBudget(String restaurant_id) async {
    var now = DateTime.now();
    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";

    try {
      var data = await firebase
          .collection("receipts")
          .doc(restaurant_id)
          .collection("months")
          // .doc(month_id)
          .doc("augut-2022")
          .get();
      print(data);
      return (data.data()!["total"] as int).toDouble();
    } catch (e) {
      print(e);
    }
    return 0;
  }

  Future<void> setMonthlyBudgetFirebase(
      String restaurant_id, Map<String, dynamic> data, double total) async {
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
    var day_id = "day-${now.day}";

    var docref = firebase
        .collection("receipts")
        .doc(restaurant_id)
        .collection("months")
        .doc(month_id);

    await docref.collection("days").doc(day_id).collection("items").add(data);

    await firebase.runTransaction((transaction) async {
      final snapshot = await transaction.get(docref);

      if (snapshot.data() == null || snapshot.data()!.isEmpty) {
        transaction.set(docref, {"total": total});
      } else {
        final newTotalValue = snapshot.get("total") + total;
        transaction.update(docref, {"total": newTotalValue});
      }
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
    // var batch = firebase.batch();
    // for (var element in data) {
    //   var docRef = ref
    //       .collection("days")
    //       .doc(day_id)
    //       .collection("items")
    //       .doc(); //automatically generate unique id
    //   batch.set(docRef, element);
    // } // await FirebaseFirestore.instance
    // batch.update(ref, {"total": total});
    // batch.commit();
  }

  Future<void> getMonthlyBudgetFirebase(String restaurant_id) async {
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
    var day_id = "day-${now.day}";
    var data = await firebase
        .collection("receipts")
        .doc(restaurant_id)
        .collection("months")
        .doc(month_id)
        .collection("days")
        .get();

    print(data);

    // .orderBy("population")
    // .startAfter([lastVisible]).limit(25);
// /receipts/agosto-2022/restaurants/Wdx7fyOEzlUQFYYszyGB
    // data.docs.reduce((value, element) => null);
  }

  Future<void> addBankInfo(data, id) async {
    return await firebase.collection("restaurants").doc(id).update(data);
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

  Future<void> addBankInformation(dynamic data) async {
    // return Future.delayed(Duration(milliseconds: 600), () {
    //   return 25200.55;
    // });
  }
}
