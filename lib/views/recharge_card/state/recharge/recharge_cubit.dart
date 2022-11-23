import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:snacks_pro_app/firebase_options.dart';
import 'dart:convert';

import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/snackbar.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/utils/toast.dart';

part 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  final database = FirebaseFirestore.instance;
  final storage = AppStorage();
  RechargeCubit() : super(RechargeState.initial());

  void changeCpf(String value) {
    emit(state.copyWith(cpf: value));
  }

  void changeName(String value) {
    emit(state.copyWith(name: value));
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
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM("pt_BR").format(now)}-${now.year}";
    var day_id = "day-${now.day}";

    var fb = await database
        .collection("snacks_cards")
        .doc(month_id)
        .collection("days")
        .doc(day_id)
        .collection("recharges")
        .get();

    var data = fb.docs
        .map((e) => {
              "responsible": e.get("responsible"),
              "value": e.get("value"),
              // "created_at": e.get("created_at"),
              "created_at": "15:40",
            })
        .toList();

    return data;
  }

  Future<void> rechargeCard() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      var now = DateTime.now();

      var month_id = "${DateFormat.MMMM("pt_BR").format(now)}-${now.year}";
      var day_id = "day-${now.day}";
      var config_cards = await database
          .collection("snacks_config")
          .doc("snacks_cards")
          .collection("active_cards")
          .doc(state.card_code)
          .get();
      // config_cards.get("active_cards");
      if (config_cards.exists) {
        final dataStorage = await storage.getDataStorage("user");

        var data = state.toMap();
        data.addAll({
          "responsible": dataStorage["name"],
          "created_at": DateFormat.Hm().format(now)
        });
        await database
            .collection("snacks_cards")
            .doc(month_id)
            .collection("days")
            .doc(day_id)
            .collection("recharges")
            .add(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: AppStatus.loaded));
  }

//card_code->recharges
  readCard(String code, PageController controller) async {
    var now = DateTime.now();

    var month_id = "${DateFormat.MMMM("pt_BR").format(now)}-${now.year}";
    var day_id = "day-${now.day}";
    try {
      var response = await database
          .collection("snacks_cards")
          .doc(month_id)
          .collection("days")
          .doc(day_id)
          .collection("recharges")
          .where("card", isEqualTo: code)
          .where("active", isEqualTo: true)
          .get();

      var data = response.docs[0].data();
      debugPrint(data.toString());
      if (data.isNotEmpty) {
        await controller.animateToPage(2,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut);
        emit(state.copyWith(
            cpf: data["cpf"],
            card_code: code,
            recharge_id: response.docs[0].id,
            value: data["value"],
            name: data["name"]));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  closeCard(PageController controller) async {
    try {
      var now = DateTime.now();

      var month_id = "${DateFormat.MMMM("pt_BR").format(now)}-${now.year}";
      var day_id = "day-${now.day}";

      await database
          .collection("snacks_cards")
          .doc(month_id)
          .collection("days")
          .doc(day_id)
          .collection("recharges")
          .doc(state.recharge_id)
          .update({"active": false});

      clear(controller);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
