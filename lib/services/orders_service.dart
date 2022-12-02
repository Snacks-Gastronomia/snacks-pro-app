import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/utils/enums.dart';

class OrdersApiServices {
  final database = FirebaseFirestore.instance;

  // Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByNow(String id) {
  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByRestaurant(String id) {
    return database
        .collection("orders")
        .where("status", whereIn: [
          OrderStatus.order_in_progress.name,
          OrderStatus.ready_to_start.name,
          OrderStatus.done.name
        ])
        .where("restaurant", isEqualTo: id)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByStatus(
      OrderStatus status) {
    return database
        .collection("orders")
        .where("status", isEqualTo: status.name)
        .snapshots();
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrdersByNow() {
  //   return database
  //       .collection("orders")
  //       .where("status", isEqualTo: OrderStatus.waiting_payment.name)
  //       .snapshots();
  // }

  Future<void> changeOrderStatus(String id, OrderStatus new_status) async {
    await database
        .collection("orders")
        .doc(id)
        .update({"status": new_status.name});

    // await database
    //     .collection("orders")
    //     .doc(id)
    // .update({"status": new_status.name});
  }
}
