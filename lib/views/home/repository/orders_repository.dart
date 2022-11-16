import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/services/orders_service.dart';

class OrdersRepository {
  final services = OrdersApiServices();

  Future<dynamic> createOrder(Map<String, dynamic> data) async {
    // return await services.createOrder(data);
  }

  Future<dynamic> createItemstoOrder(
      List<Map<String, dynamic>> data, String doc_id) async {
    // return await services.createItemstoOrder(data, doc_id);
  }

  Stream<QuerySnapshot> fetchOrdersByRestaurantId(String id) {
    // return await services.getOrdersByRestaurantId(id);
    return services.getOrdersByNow(id);
  }

  // Stream<QuerySnapshot> fetchOrdersByUserId(String id) {
  // return services.getOrdersByUserId(id);
  // }
}
