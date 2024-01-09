import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';

class ConferenceService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}
