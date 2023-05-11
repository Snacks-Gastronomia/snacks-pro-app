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
          OrderStatus.ready_to_start.name
        ])
        .where("restaurant", isEqualTo: id)
        .orderBy("created_at", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByStatus(
      OrderStatus status) {
    return database
        .collection("orders")
        .where("status", isEqualTo: status.name)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersForWaiters() {
    return database
        .collection("orders")
        .where("isDelivery", isEqualTo: false)
        .where("status",
            whereIn: [OrderStatus.done.name, OrderStatus.waiting_payment.name])
        .orderBy("created_at", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByInterval(
      DateTime start, DateTime end) {
    return database
        .collection("orders")
        .where("created_at", isGreaterThanOrEqualTo: start)
        .where(
          "created_at",
          isLessThanOrEqualTo: end,
        )
        .orderBy("created_at", descending: false)
        .snapshots();
  }

  void addWaiterToOrderPayment(String id, String name) async {
    return await database
        .collection("orders")
        .doc(id)
        .update({"waiter_payment": name});
  }

  void addWaiterToOrderDelivered(String id, String name) async {
    return await database
        .collection("orders")
        .doc(id)
        .update({"waiter_delivery": name});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() {
    return database.collection("orders").snapshots();
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

  Future<void> cancelOrderByDocId(String id) async {
    return await database.collection("orders").doc(id).delete();
  }

  Future<void> updatePaymentMethod(String id, String newMethod) async {
    await database
        .collection("orders")
        .doc(id)
        .update({"payment_method": newMethod});

    // await database
    //     .collection("orders")
    //     .doc(id)
    // .update({"status": new_status.name});
  }
}
