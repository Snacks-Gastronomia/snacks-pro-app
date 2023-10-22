import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/order_response.dart';

import 'package:snacks_pro_app/utils/enums.dart';

class OrdersApiServices {
  final database = FirebaseFirestore.instance;
  final firebase = FirebaseFirestore.instance;

  Future<void> createOrder(List<Map<String, dynamic>> data) async {
    var ref = firebase.collection("orders");

    var batch = firebase.batch();
    for (var element in data) {
      var docRef = ref.doc(); //automatically generate unique id
      batch.set(docRef, element);
    } // await FirebaseFirestore.instance

    await batch.commit();
  }

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

  Future<void> addWaiterToAllOrderPayment(List<String> ids, String name) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    WriteBatch batch = firestore.batch();

    for (String? orderId in ids) {
      DocumentReference orderRef = firestore.collection('orders').doc(orderId);
      batch.update(orderRef, {'waiter_payment': name});
    }

    batch.commit().then((_) {
      print('Batch update successful!');
    }).catchError((error) {
      print('Error updating documents: $error');
    });
  }

  Future<void> addWaiterToAllOrderDelivered(
      List<String> ids, String name) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    WriteBatch batch = firestore.batch();

    for (String? orderId in ids) {
      DocumentReference orderRef = firestore.collection('orders').doc(orderId);
      batch.update(orderRef, {'waiter_delivery': name});
    }

    batch.commit().then((_) {
      print('Batch update successful!');
    }).catchError((error) {
      print('Error updating documents: $error');
    });
  }

  Future<void> addWaiterToOrderDelivered(String id, String name) async {
    return await database
        .collection("orders")
        .doc(id)
        .update({"waiter_delivery": name});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() {
    return database
        .collection("orders")
        .orderBy("created_at", descending: true)
        .limit(300)
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

  Future<void> changeManyOrderStatus(
      List<String> ids, OrderStatus new_status) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    WriteBatch batch = firestore.batch();

    for (String? orderId in ids) {
      DocumentReference orderRef = firestore.collection('orders').doc(orderId);
      batch.update(orderRef, {'status': new_status.name});
    }

    batch.commit().then((_) {
      print('Batch update successful!');
    }).catchError((error) {
      print('Error updating documents: $error');
    });
  }

  Future<void> cancelOrderByDocId(String id) async {
    return await database.collection("orders").doc(id).delete();
  }

  Future<void> updatePaymentMethod(String id, String newMethod) async {
    await database
        .collection("orders")
        .doc(id)
        .update({"payment_method": newMethod});
  }

  Future<void> updateManyPaymentMethod(
      List<String> ids, String newMethod) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    WriteBatch batch = firestore.batch();

    for (String? orderId in ids) {
      DocumentReference orderRef = firestore.collection('orders').doc(orderId);
      batch.update(orderRef, {'payment_method': newMethod});
    }

    batch.commit().then((_) {
      print('Batch update successful!');
    }).catchError((error) {
      print('Error updating documents: $error');
    });
  }
}
