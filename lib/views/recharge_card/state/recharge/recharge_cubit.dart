import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/recharge_card/repository/recharge_repositoy.dart';
import 'package:snacks_pro_app/views/recharge_card/widgets/recharge_success.dart';

part 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  final database = FirebaseFirestore.instance;
  final repository = RechargeRepository();
  final storage = AppStorage();
  final toast = AppToast();
  final modal = AppModal();
  RechargeCubit() : super(RechargeState.initial());

  void changeCpf(String value) {
    emit(state.copyWith(cpf: value));
  }

  void changeDay(int value) {
    emit(state.copyWith(day: value));
  }

  void changeName(String value) {
    emit(state.copyWith(name: value));
  }

  void changePaymentMethod(String? value) {
    emit(state.copyWith(method: value));
    print(state);
  }

  void changeFilter(String value) {
    emit(state.copyWith(filter: value, status: AppStatus.loading));
    fetchRecharges();
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

  Future<void> fetchRecharges() async {
    var response = await repository.fetchRecharges(state.filter, state.day);
    var data = treatDataResponse(response);
    var total = data.isEmpty
        ? 0.0
        : data.map((e) => e["value"]).reduce((a, b) => a + b);
    emit(state.copyWith(
        status: AppStatus.loaded,
        recharges: data,
        totalRechargesValue: double.parse(total.toString())));
  }

  treatDataResponse(List items) {
    return items
        .map((e) => {
              "customer": e["nomeCartao"],
              "value": e["Value"],
              "created_at": DateFormat("HH:mm")
                  .format(DateTime.parse(e["createdAt"]).toLocal()),
            })
        .toList();
  }

  Future<void> rechargeCard(context) async {
    var response = await repository.rechargeCard(state.card_code, state.value);

    if (response != null) {
      emit(state.copyWith(status: AppStatus.error));
      toast.init(context: context);
      toast.showToast(
          context: context,
          content: response?["descricaoErro"] ?? "",
          type: ToastType.error);
    } else {
      await modal.showModalBottomSheet(
          context: context, content: const RechargeSuccess());
    }
  }

  Future<void> createOrderAndRecharge(context) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      var response =
          await repository.createOrderAndRecharge(state.toMap(), state.value);

      if (response != null) {
        emit(state.copyWith(status: AppStatus.error));
        toast.init(context: context);
        toast.showToast(
            context: context,
            content: response?["descricaoErro"] ?? "",
            type: ToastType.error);
      } else {
        await modal.showModalBottomSheet(
            context: context, content: const RechargeSuccess());
      }
    } catch (e) {
      debugPrint("Debug error $e");
    }
    emit(state.copyWith(status: AppStatus.loaded));
  }

//card_code->recharges
  readCard(String code, PageController controller, context) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
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
      emit(state.copyWith(status: AppStatus.loaded));
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
