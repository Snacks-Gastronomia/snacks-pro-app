import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:http/http.dart' as http;

class AppNotification {
  final firebase = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final http.Client httpClient = http.Client();
  generateTokenAndSave({required String docID}) async {
    // var userToken = await getUserToken(docID: docID);
    String? token = await generateToken();
    // if (userToken?.isEmpty ?? true) {
    //   print(docID);
    await firebase
        .collection("employees")
        .doc(docID)
        .set({"token": token}, SetOptions(merge: true));
    // }
    return token;
  }

  generateToken() async {
    String? token = await firebaseMessaging.getToken();
    return token;
  }

  Future<String?> getUserToken({required String docID}) async {
    var data = await firebase.collection("employees").doc(docID).get();
    return data.data()?["token"];
  }

  Future<List<String>> getUsersTokenByOccupation(
      {required AppPermission permission}) async {
    var data = await firebase
        .collection("employees")
        .where("access_level", isEqualTo: permission.name)
        .get();

    List<String> list = [];
    data.docs.map((e) async {
      String token = e.data()["token"].toString();
      list.add(token);
    }).toList();

    return list;
  }

  sendNotification(
      {required String token, required String title, required String message}) {
    // FirebaseMessaging.onBackgroundMessage((message) => message.);
    firebaseMessaging.sendMessage(
        to: token,
        data: {"title": title},
        messageType: "orders",
        messageId: UniqueKey().toString());
  }

  Future<void> sendMulptipleNotifications(
      {required List<String> tokens,
      required String title,
      required String message,
      required String messageType}) async {
    const headers = {
      "Authorization":
          "key=AAAA1qkWSGw:APA91bGkREzG6FykGtMncKkrCx3lWTc7U_ji958sNGr7mP0dO9Ba6xMd5Rf87-rncT_XVmQ0_mE92vDoDngjxzh3AxCETq4UKN3H7iV-UUX76nJqSCPszSj7uVhl687m3j9FObsPQEdp",
      "Content-Type": "application/json"
    };
    var path = "/fcm/send";
    final url = Uri.https("fcm.googleapis.com", path);

    try {
      final data = {
        "registration_ids": tokens,
        "light_on_duration": "3.5s",
        "notification": {
          "title": title,
          "body": message,
        },
        "time_to_live": 200,
        "messageType": messageType,
        "priority": "HIGH"
      };
      final http.Response response =
          await httpClient.post(url, headers: headers, body: data);

      if (response.statusCode != 200) {
        throw "Not possible send mensage";
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendToWaiters({required String code}) async {
    List<String> users =
        await getUsersTokenByOccupation(permission: AppPermission.waiter);
    await sendMulptipleNotifications(
        tokens: users,
        title: "Pedido #$code pronto",
        message: "Pedido está pronto para ser levado até a mesa.",
        messageType: "orders");
  }
}
