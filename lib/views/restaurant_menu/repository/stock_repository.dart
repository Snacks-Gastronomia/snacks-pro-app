import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/items_service.dart';
import 'package:snacks_pro_app/services/stock_service.dart';

class ItemsStockRepository {
  final services = ItemsApiServices();

  Future<void> postItem(Item item) async {
    try {
      await services.postItem(item);
    } catch (e) {
      throw e.toString();
    }
  }
}
