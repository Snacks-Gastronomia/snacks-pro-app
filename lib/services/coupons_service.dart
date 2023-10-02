import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/utils/storage.dart';

class CouponsService {
  final firebase = FirebaseFirestore.instance;
  final storage = AppStorage();
  String restaurantId = '';

  Future<void> getId() async {
    var data = await storage.getDataStorage("user");
    restaurantId = data["restaurant"]["id"];
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCoupons() async {
    try {
      await getId();
      return firebase.collection("coupons").doc(restaurantId).get();
    } catch (e) {
      rethrow;
    }
  }
}
