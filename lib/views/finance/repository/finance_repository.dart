import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/bank_model.dart';
import 'package:snacks_pro_app/services/finance_service.dart';

class FinanceRepository {
  final FinanceApiServices services;

  FinanceRepository({
    required this.services,
  });

  Future<int> getOrdersCount(String restaurant_id) async {
    try {
      return await services.getOrdersCount(restaurant_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addBankData(Map data, String id) async {
    try {
      return await services.addBankInfo(data, id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<int> getEmployeesCount(String restaurant_id) async {
    try {
      return await services.getEmployeesCount(restaurant_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> getMonthlyBudget(String restaurant_id) async {
    try {
      return await services.getMonthlyBudget(restaurant_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMonthlyOrders(
      String restaurant_id) async {
    try {
      return await services.getMonthlyOrders(restaurant_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDayOrders(
      String restaurant_id, String day) async {
    try {
      return await services.getDayOrders(restaurant_id, day);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getExpenses() async {
    try {
      return await services.getRestaurantExpenses();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BankModel> fetchBankInformations(String user_id) async {
    try {
      var data = await services.getBankInformations(user_id);

      return BankModel.fromMap(data.data()!);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>> fetchBanks() async {
    try {
      return await services.getBanks();
    } catch (e) {
      throw e.toString();
    }
  }
}
