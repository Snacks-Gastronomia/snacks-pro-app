import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/services/orders_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';

class OrdersRepository {
  final services = OrdersApiServices();

  Future<dynamic> createOrder(Map<String, dynamic> data) async {
    // return await services.createOrder(data);
  }

  Future<dynamic> createItemstoOrder(
      List<Map<String, dynamic>> data, String doc_id) async {
    // return await services.createItemstoOrder(data, doc_id);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchOrdersByRestaurantId(
      String id) {
    // return await services.getOrdersByRestaurantId(id);
    return services.getOrdersByRestaurant(id);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchOrdersByStatus(
      OrderStatus status) {
    // return await services.getOrdersByRestaurantId(id);
    return services.getOrdersByStatus(status);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrders(
      {bool withDelivery = false}) {
    // return await services.getOrdersByRestaurantId(id);
    return services.getAllOrders(withDelivery: withDelivery);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrdersForWaiters() {
    // return await services.getOrdersByRestaurantId(id);
    return services.getOrdersForWaiters();
  }

  updateStatus(String id, OrderStatus new_status) async {
    // return await services.getOrdersByRestaurantId(id);

    try {
      return await services.changeOrderStatus(id, new_status);
    } catch (e) {
      print(e);
    }
  }

  updatePaymentMethod(String id, String newMethod) async {
    // return await services.getOrdersByRestaurantId(id);

    try {
      return await services.updatePaymentMethod(id, newMethod);
    } catch (e) {
      print(e);
    }
  }

  void addWaiterToOrderPayment(String name, String id) {
    try {
      return services.addWaiterToOrderPayment(id, name);
    } catch (e) {
      print(e);
    }
  }

  // Stream<QuerySnapshot> fetchOrdersByUserId(String id) {
  // return services.getOrdersByUserId(id);
  // }
}
