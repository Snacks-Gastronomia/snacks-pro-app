import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/stock_service.dart';

class StockRepository {
  final StockApiServices services;
  StockRepository({
    required this.services,
  });

  Future<void> postItem(Item item) async {
    try {
      await services.postItem(item);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>?> fetchStockItems() async {
    try {
      final List items = await services.getStockItems();

      return items;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>?> fetchQueryStockItems(String query) async {
    try {
      final List items = await services.getStockItemsByQuery(query);

      return items;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>?> fetchCategories() async {
    try {
      final List categories = await services.getCategories();

      return categories;
    } catch (e) {
      throw e.toString();
    }
  }
}
