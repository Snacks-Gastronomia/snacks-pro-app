import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:snacks_pro_app/services/firebase/database.dart';
import 'package:snacks_pro_app/services/firebase/phone_auth.dart';

class AuthApiServices {
  final db = FirebaseDataBase();
  final fbauth = FirebasePhoneAuthentication();
  final http.Client httpClient = http.Client();
  final database = FirebaseFirestore.instance;

  Future<void> postUser(
      {required String name,
      required String phone,
      required String address}) async {
    print({name, phone, address});
  }

  // Future<void> creatUser({required String address, required String uid}) async {
  //   Map<String, String> data = {
  //     "uid": uid,
  //     "address": address,
  //   };
  //   try {
  //     await db.createDocumentToCollection(collection: "users", data: data);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> update({required data, required String doc}) async {
    database.collection("employees").doc(doc).update(data);
  }

  Future<User?> otpValidation(String verificationID, String pin) async {
    try {
      final user = await fbauth.verifyCode(verificationID, pin);
      print(user);
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> sendOtpCode(String number) async {
    try {
      return await fbauth.sendCode(number);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> userAlreadyRegistred(String phone) async {
    final doc = await database
        .collection("employees")
        .where("phone_number", isEqualTo: phone)
        .get();
    var docs = doc.docs;
    if (docs.isNotEmpty) {
      Map<String, dynamic> data = {"id": docs[0].id};
      data.addAll(docs[0].data());
      return data;
    }
    return null;
  }
}
