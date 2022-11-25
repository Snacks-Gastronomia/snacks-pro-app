import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/bank_model.dart';
import 'package:snacks_pro_app/services/employees_service.dart';
import 'package:snacks_pro_app/services/finance_service.dart';

class FinanceRepository {
  final FinanceApiServices services;
  final empServices = EmployeesApiServices();

  FinanceRepository({
    required this.services,
  });

  Future<void> addBankData(Map data, String id) async {
    try {
      return await services.saveBankInfo(data, id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      return await services.deleteExpense(id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      return await services.deleteRestaurant(id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> saveExpense(Map data) async {
    try {
      return await services.saveExpense(data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateRestaurant(Map data, docID) async {
    try {
      return await services.updateRestaurant(data, docID);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> saveRestaurantAndOwner(
      Map<String, dynamic> data, Map<String, dynamic> owner) async {
    try {
      var doc = await services.saveRestaurant(data);

      Map<String, Map<String, dynamic>> restaurant = {
        "restaurant": {"id": doc.id, "name": data["name"]}
      };
      owner.addAll(restaurant);
      await empServices.postEmployee(owner);
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRestaurants() {
    try {
      return services.getRestaurants();
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getExpensesStream() {
    try {
      return services.getRestaurantExpensesStream();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BankModel> fetchBankInformations(String user_id) async {
    try {
      var data = await services.getBankInformations(user_id);

      return data.data() != null
          ? BankModel.fromMap(data.data()!)
          : BankModel.initial();
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
