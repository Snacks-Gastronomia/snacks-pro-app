import 'dart:convert';

class BankModel {
  final String owner;
  final String bank;
  final String account;
  final String agency;
  BankModel({
    required this.owner,
    required this.bank,
    required this.account,
    required this.agency,
  });

  factory BankModel.initial() =>
      BankModel(owner: "", bank: "", account: "", agency: "");
  BankModel copyWith({
    String? owner,
    String? bank,
    String? account,
    String? agency,
  }) {
    return BankModel(
      owner: owner ?? this.owner,
      bank: bank ?? this.bank,
      account: account ?? this.account,
      agency: agency ?? this.agency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bank_owner': owner,
      'bank_name': bank,
      'bank_account': account,
      'bank_agency': agency,
    };
  }

  factory BankModel.fromMap(Map<String, dynamic> map) {
    return BankModel(
      owner: map['bank_owner'] ?? '',
      bank: map['bank_name'] ?? '',
      account: map['bank_account'] ?? '',
      agency: map['bank_agency'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BankModel.fromJson(String source) =>
      BankModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BankModel( owner: $owner, bank: $bank, account: $account, agency: $agency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankModel &&
        other.owner == owner &&
        other.bank == bank &&
        other.account == account &&
        other.agency == agency;
  }

  @override
  int get hashCode {
    return owner.hashCode ^ bank.hashCode ^ account.hashCode ^ agency.hashCode;
  }
}
