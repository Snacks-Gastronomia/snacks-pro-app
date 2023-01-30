import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:snacks_pro_app/firebase_options.dart';
import 'package:snacks_pro_app/services/beerpass_service.dart';
import 'dart:convert';

import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/snackbar.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/recharge_card/repository/recharge_repositoy.dart';

part 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  final database = FirebaseFirestore.instance;
  final repository = RechargeRepository();
  final storage = AppStorage();
  final toast = AppToast();
  RechargeCubit() : super(RechargeState.initial());

  void changeCpf(String value) {
    emit(state.copyWith(cpf: value));
  }

  void changeName(String value) {
    emit(state.copyWith(name: value));
  }

  void changePaymentMethod(String? value) {
    emit(state.copyWith(method: value?.toLowerCase()));
    print(state);
  }

  void changeFilter(String value) {
    emit(state.copyWith(filter: value));
    print(state);
  }

  void changeValue(String value) {
    emit(state.copyWith(value: double.parse(value)));
  }

  void changeCode(String value) {
    emit(state.copyWith(card_code: value));
  }

  void clear(PageController controller) async {
    await controller.animateToPage(0,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    emit(state.copyWith(
      cpf: "",
      name: "",
      value: 0,
      card_code: "",
      recharge_id: "",
    ));
  }

  Future<List<dynamic>> fetchRecharges() async {
    // var now = DateTime.now();

    // var month_id = "${DateFormat.MMMM("pt_BR").format(now)}-${now.year}";
    // var day_id = "day-${now.day}";

    // var fb = await database
    //     .collection("snacks_cards")
    //     .doc(month_id)
    //     .collection("days")
    //     .doc(day_id)
    //     .collection("recharges")
    //     .get();

    var response = await repository.fetchRecharges();
    print(response);
    var data = response
        .map((e) => {
              "responsible": e["nomeUsuario"],
              "value": e["Value"],
              // "method": e["Value"],
              "created_at":
                  DateFormat("HH:m").format(DateTime.parse(e["createdAt"])),
            })
        .toList();

    return data;
  }

  Future<void> rechargeCard() async {
    await repository.rechargeCard(state.card_code, state.value);
  }

  Future<void> createOrderAndRecharge() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      // var now = DateTime.now();

      // var month_id = "${DateFormat.MMMM("pt_BR").format(now)}-${now.year}";
      // var day_id = "day-${now.day}";
      // var config_cards = await database
      //     .collection("snacks_config")
      //     .doc("snacks_cards")
      //     .collection("active_cards")
      //     .doc(state.card_code)
      //     .get();
      // config_cards.get("active_cards");

      await repository.createOrderAndRecharge(state.toMap(), state.value);
      // if (config_cards.exists) {
      //   final dataStorage = await storage.getDataStorage("user");

      //   var data = state.toMap();
      //   data.addAll({
      //     "responsible": dataStorage["name"],
      //     "created_at": DateFormat.Hm().format(now)
      //   });
      //   await database
      //       .collection("snacks_cards")
      //       .doc(month_id)
      //       .collection("days")
      //       .doc(day_id)
      //       .collection("recharges")
      //       .add(data);
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: AppStatus.loaded));
  }

//card_code->recharges
  readCard(String code, PageController controller) async {
    // var now = DateTime.now();
    // var month_id = "${DateFormat.MMMM("pt_BR").format(now)}-${now.year}";
    // var day_id = "day-${now.day}";
    try {
      // var response = await database
      //     .collection("snacks_cards")
      //     .doc(month_id)
      //     .collection("days")
      //     .doc(day_id)
      //     .collection("recharges")
      //     .where("card", isEqualTo: code)
      //     .where("active", isEqualTo: true)
      //     .get();

      var response = await repository.getCard(code);

      var data = response;
      debugPrint(data.toString());
      if (data != null) {
        await controller.animateToPage(2,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut);
        emit(state.copyWith(
            cpf: data["cpf"],
            card_code: code,
            recharge_id: data["id"],
            value: double.parse(data["saldo"].toString()),
            name: data["nome"]));
      }
      // else {
      //   return null;
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  closeCard(PageController controller) async {
    try {
      await repository.closeOrderAndCard(state.toMap());
      clear(controller);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
