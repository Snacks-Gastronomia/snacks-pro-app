import 'package:snacks_pro_app/services/auth_service.dart';

class AuthenticateRepository {
  final AuthApiServices services;

  AuthenticateRepository({
    required this.services,
  });

  Future<dynamic> otpVerification(String verificationID, String pin) async {
    try {
      return await services.otpValidation(verificationID, pin);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String?> sendCode(String number) async {
    try {
      return await services.sendOtpCode(number);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateUser(Map<String, dynamic> data, String doc) async {
    try {
      return await services.update(data: data, doc: doc);
    } catch (e) {}
  }

  Future<Map<String, dynamic>?> checkUser({required String phone}) async {
    try {
      return await services.userAlreadyRegistred(phone);
    } catch (e) {
      throw e.toString();
    }
  }
}
