import 'package:flutter/material.dart';

class ConferenceStore {
  TextEditingController dinheiroController = TextEditingController();
  TextEditingController creditoController = TextEditingController();
  TextEditingController debitoController = TextEditingController();
  TextEditingController pixController = TextEditingController();

  ValueNotifier<double> total = ValueNotifier<double>(0);
  ValueNotifier<double> totalDinheiro = ValueNotifier<double>(0);
  ValueNotifier<double> totalCredito = ValueNotifier<double>(0);
  ValueNotifier<double> totalDebito = ValueNotifier<double>(0);
  ValueNotifier<double> totalPix = ValueNotifier<double>(0);
}
