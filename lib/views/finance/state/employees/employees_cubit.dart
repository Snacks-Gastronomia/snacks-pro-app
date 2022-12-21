import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/models/employee_model.dart';
import 'package:snacks_pro_app/services/employees_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/repository/employees_repository.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  final storage = AppStorage();
  final repository = EmployeesRepository(services: EmployeesApiServices());

  EmployeesCubit() : super(EmployeesState.initial()) {
    // fetchData();
  }

  void convertData(QuerySnapshot<Map<String, dynamic>> event) {
    double total = 0;
    List<EmployeeModel> data = event.docs.map((e) {
      var data = e.data();
      var el = EmployeeModel.fromMap(data);

      total += data["salary"];

      return el.copyWith(id: e.id);
    }).toList();

    emit(state.copyWith(
        employees: data,
        amount: data.length,
        expenses: total,
        status: AppStatus.loaded));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchData(
      user_id, restaurant_id) {
    emit(state.copyWith(status: AppStatus.loading));
    return repository.fetchEmployees(user_id, restaurant_id);

    // await for (final event in response) {
    //   convertData(event);
    // }
    // print(response.docs[0]);
  }

  saveEmployee() async {
    final emp = state.newEmployee;
    // if (emp != null) {
    if (emp.access_level.isEmpty) {
      emp.copyWith(access_level: AppPermission.employee.name);
    } else {
      emp.copyWith(access_level: emp.access_level.stringFromDisplayEnum.name);
    }

    var data = emp.toMap();

    if (state.updateEmp) {
      await repository.updateEmployee(emp.id!, data);
    } else {
      var user = await storage.getDataStorage("user");
      data.addAll({"restaurant": user["restaurant"]});

      await repository.createEmployee(data);
    }
    clearSelect();
  }
  // }

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
    print(state);
  }

  void changePhoneNumber(String value) {
    var emp = state.newEmployee;

    emit(state.copyWith(newEmployee: emp.copyWith(phone_number: value)));
    print(state);
  }

  void changeOcupation(String value) {
    var emp = state.newEmployee;

    emit(state.copyWith(newEmployee: emp.copyWith(ocupation: value)));
    print(state);
  }

  void changePermission(String? value) {
    if (value != null) {
      var emp = state.newEmployee;

      value = value.stringFromDisplayEnum.name;
      emit(state.copyWith(newEmployee: emp.copyWith(access_level: value)));
    }
    print(state);
  }

  void changeSalary(String value) {
    var emp = state.newEmployee;

    emit(state.copyWith(
        newEmployee: emp.copyWith(
            salary: value.isNotEmpty ? double.tryParse(value) : 0)));
    print(state);
  }
}
