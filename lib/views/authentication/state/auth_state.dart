part of "auth_cubit.dart";

class AuthState {
  final String password;
  final String cofirm_password;
  final bool obscure_pass;
  final String phone;
  final Map<String, dynamic> userDoc;
  final String verificationID;
  final bool firstAccess;
  final AppStatus? status;
  final String? error;
  AuthState({
    required this.password,
    required this.cofirm_password,
    required this.obscure_pass,
    required this.phone,
    required this.userDoc,
    required this.verificationID,
    required this.firstAccess,
    this.status,
    this.error,
  });

  factory AuthState.initial() => AuthState(
      userDoc: {},
      cofirm_password: "",
      password: "",
      error: "",
      phone: "",
      firstAccess: false,
      obscure_pass: true,
      verificationID: "",
      status: AppStatus.initial);

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'phone': phone,
      'verificationID': verificationID,
      'error': error,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'AuthState(password: $password, phone: $phone, verificationID: $verificationID, status: $status, error: $error)';
  }

  @override
  int get hashCode {
    return password.hashCode ^
        cofirm_password.hashCode ^
        obscure_pass.hashCode ^
        phone.hashCode ^
        userDoc.hashCode ^
        verificationID.hashCode ^
        firstAccess.hashCode ^
        status.hashCode ^
        error.hashCode;
  }

  AuthState copyWith({
    String? password,
    String? cofirm_password,
    bool? obscure_pass,
    String? phone,
    Map<String, dynamic>? userDoc,
    String? verificationID,
    bool? firstAccess,
    AppStatus? status,
    String? error,
  }) {
    return AuthState(
      password: password ?? this.password,
      cofirm_password: cofirm_password ?? this.cofirm_password,
      obscure_pass: obscure_pass ?? this.obscure_pass,
      phone: phone ?? this.phone,
      userDoc: userDoc ?? this.userDoc,
      verificationID: verificationID ?? this.verificationID,
      firstAccess: firstAccess ?? this.firstAccess,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.password == password &&
        other.cofirm_password == cofirm_password &&
        other.obscure_pass == obscure_pass &&
        other.phone == phone &&
        mapEquals(other.userDoc, userDoc) &&
        other.verificationID == verificationID &&
        other.firstAccess == firstAccess &&
        other.status == status &&
        other.error == error;
  }
}
