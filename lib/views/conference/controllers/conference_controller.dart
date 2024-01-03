import 'package:flutter/material.dart';
import 'package:snacks_pro_app/views/conference/store/conference_store.dart';

class ConferenceController {
  final ConferenceStore store = ConferenceStore();

  void setTotal(TextEditingController controller) {
    store.total.value = double.parse(controller.text);
  }

  void setTotalDinheiro(TextEditingController controller) {
    store.totalDinheiro.value = double.parse(controller.text);
    print('total dinheiro: ${store.totalDinheiro.value}');
  }

  void setTotalCredit(TextEditingController controller) {
    store.totalCredito.value =
        double.parse(controller.text.replaceAll('.', ''));
    print('total Credito: ${store.totalCredito.value}');
  }

  void setTotalDebito(TextEditingController controller) {
    store.totalDebito.value = double.parse(controller.text.replaceAll('.', ''));
    print('total Debito: ${store.totalDebito.value}');
  }

  void setTotalPix(TextEditingController controller) {
    store.totalPix.value = double.parse(controller.text.replaceAll('.', ''));
    print('total Pix: ${store.totalPix.value}');
  }
}
