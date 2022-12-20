import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/firebase/database.dart';

class ItemsApiServices {
  final http.Client httpClient = http.Client();
  final database = FirebaseFirestore.instance;
  final custom = FirebaseDataBase();

  Stream<QuerySnapshot<Map<String, dynamic>>> searchQuery(
      String query, restaurant_id) {
    return database
        .collection("menu")
        .orderBy("title")
        .where("restaurant_id", isEqualTo: restaurant_id)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getItems(
      String? restaurant_id, DocumentSnapshot? document,
      {int limit = 5}) {
    try {
      var ref = database
          .collection("menu")
          .where("restaurant_id", isEqualTo: restaurant_id)
          .limit(limit);
      if (document != null) {
        return ref.startAfterDocument(document).snapshots();
      }
      return ref.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMoreItems(
      String? restaurant_id, DocumentSnapshot documentSnapshot,
      {int limit = 8}) {
    try {
      return database
          .collection("menu")
          .where("restaurant_id", isEqualTo: restaurant_id)
          .startAfterDocument(documentSnapshot)
          .limit(limit)
          .get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postItem(Item item) async {
    try {
      await custom.createDocumentToCollection(
          collection: "menu", data: item.toMap());
    } catch (e) {
      print(e);
    }
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getMoreItems(
  //     String? restaurant_id, DocumentSnapshot documentSnapshot,
  //     {int limit = 8}) {
  //   try {
  //     return database
  //         .collection("menu")
  //         .where("restaurant_id", isEqualTo: restaurant_id)
  //         .startAfterDocument(documentSnapshot)
  //         .limit(limit)
  //         .snapshots();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
