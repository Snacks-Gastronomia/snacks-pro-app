import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:snacks_pro_app/utils/enums.dart';
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
    emit(state.copyWith(method: value));
    print(state);
  }

  void changeFilter(String value) {
    String? filter;
    if (value == "Pix") {
      filter = "pix";
    } else if (value == "Cartão de crédito") {
      filter = "creditCard";
    } else if (value == "Cartão de débito") {
      filter = "debitCard";
    } else if (value == "Dinheiro") {
      filter = "money";
    }
    emit(state.copyWith(recharges: []));
    fetchRecharges(filter: filter);
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

  Future<void> fetchRecharges({String? filter = "notSet"}) async {
    var response = await repository.fetchRecharges(filter);
    var data = response
        .map((e) => {
              "responsible": e["nomeUsuario"],
              "value": e["Value"],
              "created_at":
                  DateFormat("HH:m").format(DateTime.parse(e["createdAt"])),
            })
        .toList();

    emit(state.copyWith(recharges: data));
  }

  Future<void> rechargeCard() async {
    await repository.rechargeCard(state.card_code, state.value);
  }

  Future<void> createOrderAndRecharge(context) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      var response =
          await repository.createOrderAndRecharge(state.toMap(), state.value);

      if (response != null) {
        toast.init(context: context);
        toast.showToast(
            context: context,
            content: response?["descricaoErro"] ?? "",
            type: ToastType.info);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: AppStatus.loaded));
  }

//card_code->recharges
  readCard(String code, PageController controller, context) async {
    try {
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
      } else {
        toast.init(context: context);
        toast.showToast(
            context: context,
            content: "Snacks card não reconhecido",
            type: ToastType.info);
      }
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
