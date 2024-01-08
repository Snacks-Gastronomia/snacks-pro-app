import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';
import 'package:snacks_pro_app/views/conference/store/conference_store.dart';

class ConferenceService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ConferenceStore store = ConferenceStore();

  void createConference(ConferenceModel conferenceModel) {
    firestore.collection('conferences').add(conferenceModel.toMap());
    debugPrint('Conferência criada com sucesso!');
  }

  Future<bool> verifyConference() {
    DateTime sixHoursAgo = DateTime.now().subtract(const Duration(hours: 6));
    Timestamp sixHoursAgoTimestamp = Timestamp.fromDate(sixHoursAgo);
    Future<bool> result = firestore
        .collection('conferences')
        .where('date', isGreaterThanOrEqualTo: sixHoursAgoTimestamp)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          debugPrint('Não existe conferência aberta!');
          return false;
        } else {
          debugPrint('Existe conferência aberta!');
          return true;
        }
      },
    );
    return result;
  }

  Future<List<ConferenceModel>> getConference() async {
    debugPrint('Buscando Conferências');
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('conferences')
          .orderBy('date', descending: true)
          .get();
      List<ConferenceModel> conferences = querySnapshot.docs
          .map((doc) =>
              ConferenceModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      debugPrint('Conferências carregadas com sucesso!');
      return conferences;
    } catch (e) {
      debugPrint('Erro ao carregar conferências!');
      rethrow;
    }
  }

  Future<List<ConferenceModel>> getConferenceTeste() async {
    debugPrint('Buscando Conferências');
    List<ConferenceModel> conferences = [
      store.conferenceModel,
      store.conferenceModelMock
    ];
    return conferences;
  }
}
