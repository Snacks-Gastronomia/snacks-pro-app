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
          .add(coupom.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
