import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/models/employee_model.dart';
import 'package:snacks_pro_app/services/employees_service.dart';

class EmployeesRepository {
  final EmployeesApiServices services;

  EmployeesRepository({
    required this.services,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchEmployees(
      String uid, String restaurant_id) {
    try {
      return services.getEmployees(uid, restaurant_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateAppAccess(bool access, String employee_id) async {
    try {
      return await services.changeAccess(access, employee_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeEmployee(String employee_id) async {
    try {
      return await services.deleteEmployee(employee_id);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> emp) async {
    try {
      return await services.updateEmployee(id, emp);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> createEmployee(Map<String, dynamic> emp) async {
    try {
      return await services.postEmployee(emp);
    } catch (e) {
      throw e.toString();
    }
  }
}
