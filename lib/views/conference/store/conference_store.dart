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

  ConferenceModel conferenceModel = ConferenceModel(
    dinheiro: 0,
    credito: 0,
    debito: 0,
    pix: 0,
    total: 0,
    date: Timestamp.now(),
  );
}
