import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';

class CouponsService {
  final firebase = FirebaseFirestore.instance;
  final storage = AppStorage();
  String restaurantId = '';

  Future<void> getId() async {
    var data = await storage.getDataStorage("user");
    restaurantId = data["restaurant"]["id"];
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCoupons() async {
    try {
      await getId();
      return firebase
          .collection("coupons")
          .doc(restaurantId)
          .collection("coupons")
          .get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCoupom(CouponsModel coupom) async {
    try {
      await getId();
      firebase
          .collection("coupons")
          .doc(restaurantId)
          .collection("coupons")
          .doc(coupom.code)
          .set(coupom.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeCoupom(CouponsModel coupom) async {
    try {
      await getId();
      firebase
          .collection("coupons")
          .doc(restaurantId)
          .collection("coupons")
          .doc(coupom.code)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleValue(CouponsModel coupom) async {
    try {
      await getId();

      final doc = await firebase
          .collection("coupons")
          .doc(restaurantId)
          .collection("coupons")
          .doc(coupom.code)
          .get();
      final data = doc.data() as Map<String, dynamic>;
      final currentValue = data["active"] as bool;

      await firebase
          .collection("coupons")
          .doc(restaurantId)
          .collection("coupons")
          .doc(coupom.code)
          .update({"active": !currentValue});
    } catch (e) {
      rethrow;
    }
  }
}
