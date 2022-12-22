import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/models/bank_model.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/repository/finance_repository.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

part 'finance_home_state.dart';

class FinanceCubit extends Cubit<FinanceHomeState> {
  final storage = AppStorage();

  final repository = FinanceRepository(services: FinanceApiServices());
  FinanceCubit() : super(FinanceHomeState.initial());

  void fetchData() async {
    emit(state.copyWith(status: AppStatus.loading));
    var user = (await storage.getDataStorage("user"));
    var access = user["access_level"];

    var id = access == AppPermission.sadm ? "snacks" : user["restaurant"]["id"];

    var data = await Future.wait([
      repository.getMonthlyBudget(id),
      repository.fetchBankInformations(id),
    ]);
    emit(state.copyWith(status: AppStatus.loaded));

    emit(state.copyWith(
      status: AppStatus.loaded,
      budget: data[0],
      bankInfo: data[1],
      // employees_count: data[0],
      // orders_count: data[2]
    ));
  }

  Future<String> getPermission() async {
    print("init storage");
    var data = await storage.getDataStorage("user");
    return data["access_level"];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchPrinters() async* {
    // emit(state.copyWith(status: AppStatus.loading));
    var id = (await storage.getDataStorage("user"))["restaurant"]["id"];

    yield* repository.fetchPrinters(id);
  }

  insertPrinter(context) async {
    emit(state.copyWith(status: AppStatus.loading));

    var id = (await storage.getDataStorage("user"))["restaurant"]["id"];
    var newPrinter = state.printerAUX;
    print(newPrinter.toMap());
    newPrinter = newPrinter.copyWith(restaurant: id);
    if (newPrinter.ip.length >= 11) {
      await repository.insertPrinter(newPrinter.toMap());
      clearAUX();
      emit(state.copyWith(status: AppStatus.loaded));
      Navigator.pop(context);
    }
    emit(state.copyWith(status: AppStatus.loaded));
  }

  changePrinterName(value) {
    emit(state.copyWith(printerAUX: state.printerAUX.copyWith(name: value)));
    // print(state.printerAUX);
  }

  deletePrinter(String id) async {
    await repository.deletePrinter(id);
  }

  updatePrinter(context, String? id, Map? data) async {
    if (data != null) {
      var newPrinter = Printer(
          id: id,
          name: data["name"],
          goal: data["goal"],
          ip: data["ip"],
          restaurant: data["restaurant"]);
      emit(state.copyWith(printerAUX: newPrinter, status: AppStatus.editing));
    } else {
      var data = state.printerAUX;
      emit(state.copyWith(status: AppStatus.loading));

      await repository.updatePrinter(data.toMap(), data.id);

      clearAUX();
      Navigator.pop(context);
    }
  }

  changePrinterIP(value) {
    emit(state.copyWith(printerAUX: state.printerAUX.copyWith(ip: value)));
  }

  changePrinterGoal(value) {
    emit(state.copyWith(printerAUX: state.printerAUX.copyWith(goal: value)));
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchExpenses() async {
    emit(state.copyWith(status: AppStatus.loading));
    var data = await repository.getExpenses();
    // var map = data.asMap();
    print(data.length);
    if (data.isNotEmpty) {
      double total = totalExpenses(data);

      emit(state.copyWith(expenses_value: total, status: AppStatus.loaded));
    }

    return data;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchExpensesStream() {
    // emit(state.copyWith(status: AppStatus.loading));
    return repository.getExpensesStream();
  }

  double totalExpenses(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data) =>
      double.parse(data
          .map((item) => double.parse(item.data()["value"]))
          .reduce((a, b) => a + b)
          .toString());

  void adjustExpenseData(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    if (data.isNotEmpty) {
      double total = totalExpenses(data);

      emit(state.copyWith(
          expenses_value: total,
          expenses_length: data.length,
          status: AppStatus.loaded));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchRestaurants() {
    emit(state.copyWith(status: AppStatus.loading));
    return repository.getRestaurants();
  }

  Future<List<String>> fetchBanks() async {
    List<String> items = (await repository.fetchBanks())
        .where((element) => element["code"] != null)
        .map<String>((e) => e["name"] + " - 0" + e["code"].toString())
        .toList();

    items.sort();

    return items;
    // .toList()
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchFeedbacks() async {
    return await repository.fetchFeedbacks();
    // .toList()
  }

  void changeCarouselIndex(int index) {
    emit(state.copyWith(questions_carousel_index: index));
    print(state);
  }

  void changeBankAccount(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(account: value)));
    print(state);
  }

  void changeBankAgency(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(agency: value)));
    print(state);
  }

  void changeBankName(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(bank: value)));
    print(state);
  }

  void changeBankOwner(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(owner: value)));
    print(state);
  }

  void saveBankData(context) async {
    var id = (await storage.getDataStorage("user"))["restaurant"]["id"];
    await repository.addBankData(state.bankInfo.toMap(), id);
    Navigator.pop(context);
  }

  void changeRestaurantName(String value) {
    var restaurant = getRestaurantStateObject();
    restaurant.rname = value;
    emit(state.copyWith(restaurantAUX: restaurant));
    print(state);
  }

  Restaurant getRestaurantStateObject() {
    return state.restaurantAUX ??
        Restaurant(rname: "", rcategory: "", oname: "", ophone: "");
  }

  void changeRestaurantCategory(String value) {
    var restaurant = getRestaurantStateObject();
    restaurant.rcategory = value;
    emit(state.copyWith(restaurantAUX: restaurant));
    print(state);
  }

  void changeRestaurantOwnerName(String value) {
    var restaurant = getRestaurantStateObject();
    restaurant.oname = value;
    emit(state.copyWith(restaurantAUX: restaurant));
    print(state);
  }

  void changeRestaurantOwnerPhone(String value) {
    var restaurant = getRestaurantStateObject();
    restaurant.ophone = value;
    emit(state.copyWith(restaurantAUX: restaurant));
    print(state);
  }

  void saveRestaurant(context) async {
    if (state.restaurantAUX != null) {
      if (state.status != AppStatus.editing) {
        var rest = {
          "name": state.restaurantAUX!.rname,
          "category": state.restaurantAUX!.rcategory,
          "bank_account": "",
          "bank_agency": "",
          "bank_name": "",
          "bank_owner": "",
          "owner": {"name": state.restaurantAUX!.oname}
        };
        var owner = {
          "name": state.restaurantAUX!.oname,
          "phone_number": state.restaurantAUX!.ophone,
          "first_access": true,
          "access": true,
          "ocupation": "${state.restaurantAUX?.oname} adiministrador",
          "access_level": AppPermission.radm.name,
        };

        await repository.saveRestaurantAndOwner(rest, owner);
      } else {
        await repository.updateRestaurant({
          "name": state.restaurantAUX?.rname,
          "category": state.restaurantAUX?.rcategory
        }, state.restaurantAUX?.id);
      }

      clearAUX();
      Navigator.pop(context);
    }
  }

  void changeExpenseName(String value) {
    var ex = state.expenseAUX;
    ex.name = value;
    emit(state.copyWith(expenseAUX: ex));
    print(state);
  }

  void changeExpenseValue(String value) {
    var ex = state.expenseAUX;
    ex.value = double.tryParse(value) ?? 0;
    emit(state.copyWith(expenseAUX: ex));
    print(state);
  }

  void saveExpense(context) async {
    if (state.expenseAUX.name.isNotEmpty && state.expenseAUX.value != 0) {
      await repository.saveExpense(state.expenseAUX.toMap());
      clearAUX();

      Navigator.pop(context);
    }
  }

  void deleteExpense(doc_id) async {
    await repository.deleteExpense(doc_id).then((value) => fetchExpenses());
    // clearAUX();
  }

  void deleteRestaurant(doc_id) {
    repository.deleteRestaurant(doc_id);
    print(state);
    // clearAUX();
  }

  void updateRestaurant(id, data, context) {
    var rest = Restaurant(
        id: id,
        rname: data["name"],
        rcategory: data["category"],
        oname: "",
        ophone: "");
    print(rest.rname);
    emit(state.copyWith(restaurantAUX: rest, status: AppStatus.editing));
    Navigator.pushNamed(context, AppRoutes.newRestaurant)
        .then((value) => clearAUX());
  }

  clearAUX() {
    emit(state.copyWith(
        expenseAUX: null,
        restaurantAUX: null,
        printerAUX: null,
        status: AppStatus.initial));
    // print(state);
    // print("clear");
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSchedule() {
    return repository.fetchSchedule();
  }

  changeActiveSchedule({required int day, required bool value}) async {
    print(value);
    await repository.updateActiveTime(day, value);
    print(state);
  }

  changeStartTime({required int day, required String value}) async {
    await repository.updateStartTime(day, value);
    print(state);
  }

  changeEndTime({required int day, required String value}) async {
    await repository.updateEndTime(day, value);
    print(state);
  }
}
