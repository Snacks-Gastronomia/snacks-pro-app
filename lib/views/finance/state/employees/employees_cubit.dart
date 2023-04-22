import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/models/employee_model.dart';
import 'package:snacks_pro_app/services/employees_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/repository/employees_repository.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  final storage = AppStorage();
  final repository = EmployeesRepository(services: EmployeesApiServices());

  EmployeesCubit() : super(EmployeesState.initial());

  List<EmployeeModel> convertData(List<QueryDocumentSnapshot> event) {
    double total = 0;

    List<EmployeeModel> data = event.map((e) {
      var el = EmployeeModel.fromJson(jsonEncode(e.data()));

      total += el.salary;

      return el.copyWith(id: e.id);
    }).toList();

    emit(state.copyWith(
        amount: data.length, expenses: total, status: AppStatus.loaded));
    return data;
  }

  void fetchData() async {
    emit(state.copyWith(status: AppStatus.loading));
    var _storage = await storage.getDataStorage("user");
    var _stream = repository.fetchEmployees(
        _storage["uid"], _storage["restaurant"]["id"]);

    emit(state.copyWith(employees: _stream, status: AppStatus.loaded));
  }

  Future<bool> saveEmployee() async {
    final emp = state.newEmployee;

    var data = emp.toMap();

    if (state.updateEmp) {
      await repository.updateEmployee(emp.id!, data);
      return true;
    } else {
      var phone =
          await repository.fetchSingleEmployeeByPhoneNumber(emp.phone_number);

      if (phone.docs.isEmpty) {
        var user = await storage.getDataStorage("user");
        data.addAll({"restaurant": user["restaurant"]});
        await repository.createEmployee(data);
        clearSelect();
        fetchData();
        return true;
      }
      return false;
    }
  }

  disableEmployee(bool access, String id) async {
    await repository.updateAppAccess(access, id);
  }

  updateEmployee(String id, data) async {
    await repository.updateEmployee(id, data);
  }

  selectToUpdate(EmployeeModel data, context) async {
    emit(state.copyWith(newEmployee: data, updateEmp: true));
    Navigator.pushNamed(context, AppRoutes.newEmployee);
  }

  clearSelect() {
    emit(
        state.copyWith(newEmployee: EmployeeModel.initial(), updateEmp: false));
  }

  deleteEmployee(String id) async {
    await repository.removeEmployee(id);
  }

  void changeName(String value) {
    var emp = state.newEmployee;

    emit(state.copyWith(newEmployee: emp.copyWith(name: value)));
  }

  void changePhoneNumber(String value) {
    var emp = state.newEmployee;

    emit(state.copyWith(newEmployee: emp.copyWith(phone_number: value)));
  }

  void changeOcupation(String value) {
    var emp = state.newEmployee;

    emit(state.copyWith(newEmployee: emp.copyWith(ocupation: value)));
  }

  void changePermission(String? value) {
    if (value != null) {
      var emp = state.newEmployee;

      value = value.stringLabelToEnum.name;
      emit(state.copyWith(newEmployee: emp.copyWith(access_level: value)));
    }
  }

  void changeSalary(String value) {
    var emp = state.newEmployee;

    emit(state.copyWith(
        newEmployee: emp.copyWith(
            salary: value.isNotEmpty ? double.tryParse(value) : 0)));
  }
}
