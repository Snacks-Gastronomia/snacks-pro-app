import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/items_service.dart';

class ItemsRepository {
  final ItemsApiServices services;
  ItemsRepository({
    required this.services,
  });

  // Future<void> postItem(Item item) async {
  //   try {
  //     await services.postItem(item);
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchItems(
      String? restaurant, DocumentSnapshot? document) {
    try {
      return services.getItems(restaurant, document);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchMoreItems(
      String? restaurant, DocumentSnapshot document) {
    try {
      return services.getMoreItems(restaurant, document);
    } catch (e) {
      throw e.toString();
    }
  }
  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchMoreItems(
  //     String? restaurant, DocumentSnapshot document) {
  //   try {
  //     return services.getMoreItems(restaurant, document);
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchQuery(
      String query, String? category, restaurant_id) {
    try {
      return services.searchQuery(query, restaurant_id);

      // return items;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteItem(String doc) async {
    try {
      return services.deleteItem(doc);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> postItem(Item item) async {
    try {
      return services.postItem(item);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateItem(Item item) async {
    try {
      return services.updateItem(item);
    } catch (e) {
      throw e.toString();
    }
  }
}
