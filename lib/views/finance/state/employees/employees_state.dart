part of 'employees_cubit.dart';

class EmployeesState {
  final Stream<QuerySnapshot> employees;
  final int amount;
  final EmployeeModel newEmployee;
  final double expenses;
  final AppStatus status;
  final bool updateEmp;
  EmployeesState({
    required this.employees,
    required this.amount,
    required this.newEmployee,
    required this.expenses,
    required this.status,
    required this.updateEmp,
  });

  factory EmployeesState.initial() => EmployeesState(
      newEmployee: EmployeeModel.initial(),
      employees: const Stream.empty(),
      amount: 0,
      expenses: 0,
      updateEmp: false,
      status: AppStatus.initial);

  EmployeesState copyWith({
    Stream<QuerySnapshot>? employees,
    int? amount,
    bool? updateEmp,
    EmployeeModel? newEmployee,
    double? expenses,
    AppStatus? status,
  }) {
    return EmployeesState(
      employees: employees ?? this.employees,
      amount: amount ?? this.amount,
      newEmployee: newEmployee ?? this.newEmployee,
      expenses: expenses ?? this.expenses,
      updateEmp: updateEmp ?? this.updateEmp,
      status: status ?? this.status,
    );
  }
}
