import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/utils/storage.dart';

class StockServiceApi {
  final firebase = FirebaseFirestore.instance;
  final storage = AppStorage();

  getTimestampID() {
    return DateFormat.yMMMM();
  }

  newStockEntrance(rid, data,
      {String? stockItemId,
      String? entranceId,
      double pastTotal = 0,
      double pastConsume = 0,
      double pastLoss = 0}) async {
    var ref = firebase
        .collection("stock")
        .doc(rid)
        .collection("details")
        .doc(stockItemId);

    var aux = {
      "title": data["title"],
      "total": data["volume"],
      "losses": 0,
      "consumed": 0,
      "unit": data["unit"],
      "created_at": data["created_at"]
    };

    if (stockItemId != null) {
      await ref.collection("entrances").doc(entranceId).set(
          {"consumed": pastConsume, "lost": pastLoss},
          SetOptions(
            merge: true,
          ));

      aux["total"] += (pastTotal - pastConsume - pastLoss);
    }

    ref.set(
        aux,
        SetOptions(
          merge: false,
        ));

    return await ref.collection("entrances").add(data);
  }

  newStockLoss(rid, stockItemId, data) async {
    var ref = firebase
        .collection("stock")
        .doc(rid)
        .collection("details")
        .doc(stockItemId);

    await ref.set({"loss": FieldValue.increment(data["volume"])},
        SetOptions(merge: true));

    return ref.collection("losses").add(data);
  }

  newStockConsume(rid, stockItemId, data) async {
    var ref = firebase
        .collection("stock")
        .doc(rid)
        .collection("details")
        .doc(stockItemId);

    await ref.set(
        {"consumed": FieldValue.increment(double.parse(data["volume"]))},
        SetOptions(merge: true));

    return ref.collection("consume").add(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchStock(rid) {
    return firebase
        .collection("stock")
        .doc(rid)
        .collection("details")
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getConsume(rid, stockid,
      {int limit = 5}) async {
    return await firebase
        .collection("stock")
        .doc(rid)
        .collection("details")
        .doc(stockid)
        .collection("consume")
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLoss(rid, stockid,
      {int limit = 5}) async {
    return await firebase
        .collection("stock")
        .doc(rid)
        .collection("details")
        .doc(stockid)
        .collection("losses")
        .limit(limit)
        .orderBy("created_at", descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getEntrances(rid, stockid) async {
    return await firebase
        .collection("stock")
        .doc(rid)
        .collection("details")
        .doc(stockid)
        .collection("entrances")
        .get();
  }
}
