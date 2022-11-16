import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/employee_model.dart';

class EmployeesApiServices {
  final firebase = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getEmployees(
      String restaurant_id) {
    try {
      return firebase
          .collection("employees")
          .where("restaurant.id", isEqualTo: restaurant_id)
          .snapshots();
    } catch (e) {
      rethrow;
    }
    // return data;
  }

  Future<void> changeAccess(bool access, String employee_id) async {
    try {
      return await firebase
          .collection("employees")
          .doc(employee_id)
          .update({"access": access});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEmployee(String employee_id) async {
    try {
      return await firebase.collection("employees").doc(employee_id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> emp) async {
    try {
      return await firebase.collection("employees").doc(id).update(emp);
    } catch (e) {
      print(e);
    }
  }

  Future<void> postEmployee(Map<String, dynamic> emp) async {
    try {
      await firebase.collection("employees").add(emp);
    } catch (e) {
      print(e);
    }
  }
}
