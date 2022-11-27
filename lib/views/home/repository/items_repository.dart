import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/items_service.dart';

class ItemsRepository {
  final ItemsApiServices services;
  ItemsRepository({
    required this.services,
  });

  Future<void> postItem(Item item) async {
    try {
      await services.postItem(item);
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot> fetchItems(String? restaurant, String? query) {
    try {
      return services.getItems(restaurant, query.toString());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Item> fecthSingleItem(String id) async {
    try {
      return await services.getSingleItem(id);

      // return item;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchItems(
      String query, String? category, restaurant_id) async {
    try {
      return await services.queryItems(query, category, restaurant_id);

      // return items;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Item>?> fetchPopularItems() async {
    try {
      final List<Item> items = await services.getPopularItems();

      return items;
    } catch (e) {
      throw e.toString();
    }
  }
}
