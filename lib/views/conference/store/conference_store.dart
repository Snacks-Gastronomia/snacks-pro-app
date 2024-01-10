import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';

class ConferenceStore {
  TextEditingController dinheiroController = TextEditingController();
  TextEditingController creditoController = TextEditingController();
  TextEditingController debitoController = TextEditingController();
  TextEditingController pixController = TextEditingController();

  ValueNotifier<double?> total = ValueNotifier<double?>(null);
  ValueNotifier<double?> totalDinheiro = ValueNotifier<double?>(null);
  ValueNotifier<double?> totalCredito = ValueNotifier<double?>(null);
  ValueNotifier<double?> totalDebito = ValueNotifier<double?>(null);
  ValueNotifier<double?> totalPix = ValueNotifier<double?>(null);

  ConferenceModel conferenceModel = ConferenceModel.defaultValues();

  ConferenceModel conferenceModelMock = ConferenceModel(
      dinheiro: 120,
      credito: 89,
      debito: 64,
      pix: 164,
      total: 437,
      date: Timestamp.now());

  final ValueNotifier<List<DateTime?>> listDateTimeNotifier = ValueNotifier([]);
  List<DateTime> get listDateTime =>
      listDateTimeNotifier.value.cast<DateTime>();
  set listDateTime(List<DateTime?> value) => listDateTimeNotifier.value = value;
}
