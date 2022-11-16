import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/services/auth_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/md5.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/authentication/repository/auth_repository.dart';

part "auth_state.dart";

class AuthCubit extends Cubit<AuthState> {
  final encrypt = AppMD5();
  final storage = AppStorage.initStorage;

  final AuthenticateRepository repository =
      AuthenticateRepository(services: AuthApiServices());
  final auth = FirebaseAuth.instance;
  AuthCubit() : super(AuthState.initial());

  otpVerification(String value, context) async {
    final navigator = Navigator.of(context);
    emit(state.copyWith(status: AppStatus.loading));
    var user = await repository.otpVerification(state.verificationID, value);

    if (user != null) {
      navigator.pushReplacementNamed(AppRoutes.passwordScreen);

      emit(state.copyWith(status: AppStatus.loaded));
    } else {
      emit(state.copyWith(status: AppStatus.error));
    }

    return user;
  }

  void authenticateUser(context) async {
    changeStatus(AppStatus.loading);
    final navigator = Navigator.of(context);
    bool done = false;
    if (state.firstAccess) {
      createUser(context);
      done = true;
    } else {
      if (encrypt.getEncrypt(state.password) == state.userDoc["password"]) {
        // if (true) {
        done = true;
      } else {
        print("senha incorreta");
        changeStatus(AppStatus.loaded);
      }
    }
    if (done) {
      await createUserStorage();
      changeStatus(AppStatus.loaded);
      navigator.pushNamedAndRemoveUntil(
          AppRoutes.home, ModalRoute.withName(AppRoutes.restaurantAuth));
    }
  }

  Future<void> sendPhoneCodeOtp(context) async {
    final navigator = Navigator.of(context);
    changeStatus(AppStatus.loading);
    if (validateNumber) {
      var res = await checkUser();

      if (res != null) {
        try {
          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: "+55 ${state.phone}",
              verificationCompleted: (PhoneAuthCredential credential) async {},
              verificationFailed: (FirebaseAuthException e) {
                print("Não foi possível enviar o código! Tente novamente.");
              },
              codeSent: (String verificationID, int? resendToken) async {
                print("code sent");
                if (verificationID.isNotEmpty) {
                  changeVerificationId(verificationID);
                  changeStatus(AppStatus.loaded);
                  await navigator.pushNamed(AppRoutes.otp);
                }
              },
              codeAutoRetrievalTimeout: (String verificationID) async {
                if (verificationID.isNotEmpty) {
                  changeVerificationId(verificationID);
                  changeStatus(AppStatus.loaded);

                  await navigator.pushNamed(AppRoutes.otp);
                }
              },
              timeout: const Duration(seconds: 120));
        } catch (e) {
          print(e);
        }
      } else {
        navigator.pushNamed(AppRoutes.unathorizedAuth);
      }
    } else {
      print("error");
      changeStatus(AppStatus.error);
    }
  }

  void createUser(context) async {
    final data = {
      "first_access": false,
      "password": encrypt.getEncrypt(state.password),
      "uid": auth.currentUser!.uid
    };

    await repository.updateUser(data, state.userDoc["id"]);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, ModalRoute.withName(AppRoutes.restaurantAuth));
  }

  Future<void> createUserStorage() async {
    var dataStorage = {
      "name": state.userDoc["name"],
      "phone": state.userDoc["phone"],
      "ocupation": state.userDoc["ocupation"],
      "access_level": state.userDoc["access_level"],
      "companie_id": state.userDoc["companie_id"],
      "restaurant": state.userDoc["restaurant"],
      "docID": state.userDoc["id"]
    };
    print(dataStorage);
    await storage.write(key: "user", value: jsonEncode(dataStorage));
  }

  checkUser() async {
    Map<String, dynamic>? response =
        await repository.checkUser(phone: state.phone);
    print(response);
    if (response != null && response["access"] == true) {
      print('first access $response["first_access"]');
      bool access = response["first_access"];

      emit(state.copyWith(userDoc: response, firstAccess: access));
      return response;
    }
    return null;
  }

  bool get validateNumber => state.phone.length == 15;
  // bool get validatePassLength => state.password.length < 6;
  // bool get validatePassEquals => state.password != state.cofirm_password;

  String? validatePassLength(value) {
    if (state.password.length < 6) {
      return "As senhas devem ter no mínimo 6 caracteres.";
    }
  }

  String? validatePassEquals(value) {
    if (state.password != state.cofirm_password) {
      return "As senhas não coincidem.";
    }
    // emit(state.copyWith(error: ""));
    // if ( &&
    //     state.cofirm_password.isNotEmpty) {
    //   emit(state.copyWith(error: "As senhas não coincidem."));
    // }
  }

  void changeVerificationId(String value) {
    emit(state.copyWith(verificationID: value));
    print("verification id state:");
    print(state);
  }

  void changePhone(String value) {
    emit(state.copyWith(phone: value));
    // print(state);
  }

  void changeObscurePassword() {
    emit(state.copyWith(obscure_pass: !state.obscure_pass));
    // print(state);
  }

  void changePassword(String value) {
    emit(state.copyWith(password: value));
    print(state);
  }

  void changeCofirmPassword(String value) {
    emit(state.copyWith(cofirm_password: value));
    print(state);
  }

  void throwError(String message) {
    emit(state.copyWith(status: AppStatus.error, error: message));
    print(state);
  }

  void changeStatus(AppStatus status) {
    emit(state.copyWith(status: status));
  }
}
