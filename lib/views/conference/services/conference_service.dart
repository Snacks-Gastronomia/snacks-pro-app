import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';

class ConferenceService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createConference(ConferenceModel conferenceModel) {
    firestore.collection('conferences').add(conferenceModel.toMap());
    debugPrint('Conferência criada com sucesso!');
  }
}
