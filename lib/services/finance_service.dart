import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
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
    return Future.delayed(Duration(milliseconds: 600), () {
      return 25200.55;
    });
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
