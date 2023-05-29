import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/bank_model.dart';
import 'package:snacks_pro_app/services/employees_service.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/finance/repository/employees_repository.dart';

class FinanceRepository {
  final FinanceApiServices services;
  final toast = AppToast();
  final empServices = EmployeesApiServices();
  final empRepo = EmployeesRepository(services: EmployeesApiServices());

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

  Future<QuerySnapshot<Map<String, dynamic>>> getPrinterByGoal(
      String restaurant, String goal) async {
    try {
      return await services.getPrinterByGoal(restaurant, goal);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Map<String, dynamic>>?> fetchRestaurantsProfits() async {
    try {
      return await services.getRestaurantsProfits();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<int> getCountRestaurants() async {
    try {
      return await services.getCountRestaunts();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> insertPrinter(Map<String, dynamic> data) async {
    try {
      return await services.addPrinter(data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deletePrinter(String docID) async {
    try {
      return await services.deletePrinter(docID);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updatePrinter(Map<String, dynamic> data, id) async {
    try {
      return await services.updatePrinter(data, id);
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSchedule() {
    try {
      return services.getSchedule();
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchPrinters(id) {
    try {
      return services.getPrinters(id);
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

  Future<void> deleteRestaurantExpense(String id, String doc) async {
    try {
      return await services.deleteRestaurantExpense(id, doc);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteRestaurant(String rid, String owner_id) async {
    try {
      return await services.deleteRestaurant(rid, owner_id);
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

  Future<void> saveRestExpense(Map data, rest_id) async {
    try {
      return await services.saveRestExpense(data, rest_id);
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
      Map<String, dynamic> data, Map<String, dynamic> owner, context) async {
    try {
      var doc = await services.saveRestaurant(data);

      Map<String, Map<String, dynamic>> restaurant = {
        "restaurant": {"id": doc.id, "name": data["name"]}
      };
      owner.addAll(restaurant);
      var emp = await empServices.postEmployee(owner);
      await services.updateRestaurant({"owner.id": emp.id}, doc.id);
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeatures() {
    try {
      return services.getFeatures();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateFeatureValue(String doc, bool value) async {
    try {
      return await services.updateFeatureValue(doc, value);
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

  Future<dynamic> getMonthlyBudgetSnacks() async {
    try {
      return await services.getMonthlyBudgetSnacks();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMonthlyOrders(
      String restaurant_id, String month) async {
    try {
      return await services.getMonthlyOrders(restaurant_id, month);
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
      return await services.getExpenses();
    } catch (e) {
      throw e.toString();
    }
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchExpenses(doc) {
  //   try {
  //     return services.getExpensesStream(doc);
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getRestaurantExpenses(docID) async {
    try {
      return await services.getRestaurantExpenses(docID);
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

  Future<QuerySnapshot<Map<String, dynamic>>> fetchFeedbacks() async {
    try {
      return await services.getFeedbacks();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStartTime(int weekday, start) async {
    try {
      return await services.updateTime(weekday, {"start": start});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateEndTime(int weekday, end) async {
    try {
      return await services.updateTime(weekday, {"end": end});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateActiveTime(int weekday, active) async {
    try {
      return await services.updateTime(weekday, {"active": active});
    } catch (e) {
      throw e.toString();
    }
  }
}
