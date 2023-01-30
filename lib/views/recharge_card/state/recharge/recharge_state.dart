part of 'recharge_cubit.dart';

class RechargeState {
  final String name;
  final String cpf;
  final double value;
  final String recharge_id;
  final String card_code;
  final String? method;
  final String filter;
  final AppStatus? status;
  final String? error;
  RechargeState({
    required this.name,
    required this.cpf,
    required this.filter,
    required this.value,
    required this.recharge_id,
    required this.card_code,
    required this.method,
    this.status,
    this.error,
  });

  factory RechargeState.initial() => RechargeState(
        name: "",
        method: null,
        cpf: "",
        filter: "Tudo",
        value: 0,
        status: AppStatus.initial,
        error: null,
        card_code: '',
        recharge_id: '',
      );

  RechargeState copyWith({
    String? name,
    String? cpf,
    double? value,
    String? card_code,
    String? method,
    String? recharge_id,
    String? filter,
    AppStatus? status,
    String? error,
  }) {
    return RechargeState(
      name: name ?? this.name,
      method: method ?? this.method,
      filter: filter ?? this.filter,
      cpf: cpf ?? this.cpf,
      value: value ?? this.value,
      status: status ?? this.status,
      error: error ?? this.error,
      card_code: card_code ?? this.card_code,
      recharge_id: recharge_id ?? this.recharge_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': name,
      'cpf': cpf,
      'valor': value,
      'method': method,
      'rfid': card_code,
      // 'active': true,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'RechargeState(name: $name, cpf: $cpf, value: $value, status: $status,method: $method, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RechargeState &&
        other.name == name &&
        other.cpf == cpf &&
        other.value == value &&
        other.card_code == card_code &&
        other.recharge_id == recharge_id &&
        other.method == method &&
        other.status == status &&
        other.filter == filter &&
        other.error == error;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        cpf.hashCode ^
        value.hashCode ^
        status.hashCode ^
        error.hashCode;
  }
}
