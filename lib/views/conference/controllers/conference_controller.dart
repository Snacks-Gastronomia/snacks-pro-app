import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';
import 'package:snacks_pro_app/views/conference/services/conference_service.dart';
import 'package:snacks_pro_app/views/conference/store/conference_store.dart';

class ConferenceController {
  final ConferenceStore store = ConferenceStore();
  final ConferenceService service = ConferenceService();
  final AppToast toast = AppToast();

  void setTotal() {
    store.total.value = conferenceIsValidate()
        ? (store.totalDinheiro.value! +
            store.totalCredito.value! +
            store.totalDebito.value! +
            store.totalPix.value!)
        : 0;

    store.conferenceModel = ConferenceModel(
      dinheiro: store.totalDinheiro.value ?? 0,
      credito: store.totalCredito.value ?? 0,
      debito: store.totalDebito.value ?? 0,
      pix: store.totalPix.value ?? 0,
      total: store.total.value ?? 0,
      date: Timestamp.now(),
    );
  }

  bool conferenceIsValidate() {
    if (store.totalDebito.value == null ||
        store.totalCredito.value == null ||
        store.totalDinheiro.value == null ||
        store.totalPix.value == null) {
      return false;
    } else {
      return true;
    }
  }

  void setTotalDinheiro(TextEditingController controller) {
    store.totalDinheiro.value =
        double.parse(controller.text.replaceAll('.', '').replaceAll(',', '.'));
    setTotal();
    debugPrint('total dinheiro: ${store.totalDinheiro.value}');
  }

  void setTotalCredit(TextEditingController controller) {
    store.totalCredito.value =
        double.parse(controller.text.replaceAll('.', '').replaceAll(',', '.'));
    setTotal();
    debugPrint('total Credito: ${store.totalCredito.value}');
  }

  void setTotalDebito(TextEditingController controller) {
    store.totalDebito.value =
        double.parse(controller.text.replaceAll('.', '').replaceAll(',', '.'));
    setTotal();
    debugPrint('total Debito: ${store.totalDebito.value}');
  }

  void setTotalPix(TextEditingController controller) {
    store.totalPix.value =
        double.parse(controller.text.replaceAll('.', '').replaceAll(',', '.'));
    setTotal();
    debugPrint('total Pix: ${store.totalPix.value}');
  }

  void submitConference(BuildContext context) {
    toast.init(context: context);
    if (conferenceIsValidate()) {
      service.createConference(store.conferenceModel);
      toast.showToast(
        content: 'Conferência criada com sucesso',
        type: ToastType.success,
      );
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);
    } else {
      toast.showToast(
        content: 'Preencha todos os campos',
        type: ToastType.error,
      );
      Navigator.pushReplacementNamed(context, AppRoutes.conference);
    }
  }

  Color colorTotal({required double valueOne, required double valueTwo}) {
    if (valueOne < valueTwo) {
      return Colors.red;
    } else if (valueOne > valueTwo) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }
}
