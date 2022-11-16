import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:snacks_pro_app/firebase_options.dart';
import 'dart:convert';

import 'package:snacks_pro_app/utils/enums.dart';

part 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  final database = FirebaseFirestore.instance;
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
    emit(state.copyWith(cpf: "", name: "", value: 0));
  }

  Future<void> rechargeCard() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      await database
          .collection("snacks_cards")
          .doc(state.card_code)
          .collection("recharges")
          .add(state.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: AppStatus.loaded));
  }

//card_code->recharges
  readCard(String code, PageController controller) async {
    try {
      var response = await database
          .collection("snacks_cards")
          .doc(code)
          .collection("recharges")
          .where("active", isEqualTo: true)
          .get();

      var data = response.docs[0].data();
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
      await database
          .collection("snacks_cards")
          .doc(state.card_code)
          .collection("recharges")
          .doc(state.recharge_id)
          .update({"active": false});

      clear(controller);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
