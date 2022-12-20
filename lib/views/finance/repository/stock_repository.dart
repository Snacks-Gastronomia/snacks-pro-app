import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/services/stock_service.dart';

class StockRepository {
  final services = StockApiServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchStock(String restaurant_id) {
    try {
      return services.getStock(restaurant_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addStockItem(String restaurant_id, Map<String, dynamic> data) {
    try {
      return services.createStockItem(restaurant_id, data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStockItem(
      String restaurant_id, String doc, Map<String, dynamic> data) {
    try {
      return services.updateStockItem(restaurant_id, doc, data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStock(String restaurant_id, String doc, data) {
    try {
      return services.updateStock(restaurant_id, doc, data);
    } catch (e) {
      throw e.toString();
    }
  }
}
