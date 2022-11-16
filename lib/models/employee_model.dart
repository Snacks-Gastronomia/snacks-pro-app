import 'dart:convert';

class EmployeeModel {
  final String? id;
  final String name;
  final String phone_number;
  final String ocupation;
  final bool first_access;
  final double salary;
  final bool access;
  EmployeeModel({
    this.id,
    required this.name,
    required this.phone_number,
    required this.first_access,
    required this.ocupation,
    required this.salary,
    required this.access,
  });

  factory EmployeeModel.initial() => EmployeeModel(
      first_access: true,
      name: "",
      phone_number: "",
      ocupation: "",
      salary: 0,
      access: true);

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? phone_number,
    String? ocupation,
    double? salary,
    bool? access,
    bool? first_access,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone_number: phone_number ?? this.phone_number,
      ocupation: ocupation ?? this.ocupation,
      salary: salary ?? this.salary,
      access: access ?? this.access,
      first_access: first_access ?? this.first_access,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_number': phone_number,
      'first_access': first_access,
      'ocupation': ocupation,
      'salary': salary,
      'access': access,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['name'] ?? '',
      first_access: map['first_access'] ?? '',
      phone_number: map['phone_number'] ?? '',
      ocupation: map['ocupation'] ?? '',
      salary: map['salary']?.toDouble() ?? 0.0,
      access: map['access'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EmployeeModel(id: $id, name: $name, phone_number: $phone_number, ocupation: $ocupation, salary: $salary, access: $access)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmployeeModel &&
        other.id == id &&
        other.name == name &&
        other.phone_number == phone_number &&
        other.ocupation == ocupation &&
        other.salary == salary &&
        other.access == access;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone_number.hashCode ^
        ocupation.hashCode ^
        salary.hashCode ^
        access.hashCode;
  }
}
