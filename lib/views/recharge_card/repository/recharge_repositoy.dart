import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/beerpass_service.dart';
import 'package:snacks_pro_app/services/items_service.dart';

class RechargeRepository {
  final services = BeerPassService();

  Future<dynamic> getCard(String rfid) async {
    try {
      return await services.getCard(rfid, null);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> createOrderAndRecharge(
      Map<String, dynamic> data, double value) async {
    try {
      return await services.createOrder(data, value);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> rechargeCard(String rfid, double value) async {
    try {
      return await services.rechargeCard(rfid, value);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>> fetchRecharges(filter) async {
    try {
      return await services.fetchRecharges(paymentType: filter);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> closeOrderAndCard(Map<String, dynamic> data) async {
    try {
      return await services.closeCard(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
