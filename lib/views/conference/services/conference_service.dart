import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/views/conference/enums/payment_method_enum.dart';
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

  Future<List<ConferenceModel>> getConferences({
    DateTime? startDay,
    DateTime? endDay,
  }) async {
    DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    Timestamp startDayTimestamp = Timestamp.fromDate(startDay ?? sevenDaysAgo);
    Timestamp endDayTimestamp = Timestamp.fromDate(endDay ?? DateTime.now());
    debugPrint(
        'Buscando Conferências do dia $startDayTimestamp até $endDayTimestamp');
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('conferences')
          .where("date", isGreaterThanOrEqualTo: startDayTimestamp)
          .where("date", isLessThanOrEqualTo: endDayTimestamp)
          .get();
      List<ConferenceModel> conferences = querySnapshot.docs
          .map((doc) =>
              ConferenceModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      debugPrint('Conferências carregadas com sucesso!');
      return conferences;
    } catch (e) {
      debugPrint('Erro ao carregar conferências!');
      debugPrint('$e');
      rethrow;
    }
  }

  Future<List<ConferenceModel>> getConferencesTeste() async {
    debugPrint('Buscando Conferências');
    List<ConferenceModel> conferences = [
      store.conferenceModel,
      store.conferenceModelMock
    ];
    return conferences;
  }

  Future<double> getTotalSistemaByPaymentMethod(
      Timestamp timestamp, String paymentMethod) async {
    debugPrint('Buscando Pedidos');

    try {
      Timestamp fourPmTimestamp = Timestamp.fromDate(
        DateTime(timestamp.toDate().year, timestamp.toDate().month,
            timestamp.toDate().day, 16),
      );

      Timestamp oneAmTimestamp = Timestamp.fromDate(
        DateTime(timestamp.toDate().year, timestamp.toDate().month,
            timestamp.toDate().day + 1, 1),
      );

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('orders')
          .where("created_at", isGreaterThanOrEqualTo: fourPmTimestamp)
          .where("created_at", isLessThan: oneAmTimestamp)
          .where("payment_method", isEqualTo: paymentMethod)
          .get();

      List<OrderResponse?> orders = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs
              .map((doc) => OrderResponse.fromFirebase(doc))
              .toList()
          : [];

      debugPrint('Conferências carregados com sucesso!');

      double total = 0;
      if (orders.isNotEmpty) {
        for (var order in orders) {
          total += order!.value;
          debugPrint('Somando valor: ${order.value}');
          debugPrint('Total: $total');
        }
      }
      return total;
    } catch (e) {
      debugPrint('Erro ao carregar pedidos!');
      debugPrint('$e');

      rethrow;
    }
  }

  Future<ConferenceModel> getConferenceSistema(Timestamp timestamp) async {
    try {
      debugPrint('Buscando Conferências');
      double totalCredito = await getTotalSistemaByPaymentMethod(
          timestamp, PaymentMethodEnum.cartaoCredito);
      double totalDebito = await getTotalSistemaByPaymentMethod(
          timestamp, PaymentMethodEnum.cartaoDebito);
      double totalDInheiro = await getTotalSistemaByPaymentMethod(
          timestamp, PaymentMethodEnum.dinheiro);
      double totalPix = await getTotalSistemaByPaymentMethod(
          timestamp, PaymentMethodEnum.pix);
      debugPrint('Calculando Total');
      double total = totalCredito + totalDebito + totalDInheiro + totalPix;
      return ConferenceModel(
          credito: totalCredito,
          debito: totalDebito,
          dinheiro: totalDInheiro,
          pix: totalPix,
          total: total,
          date: timestamp);
    } catch (e) {
      debugPrint('Erro ao carregar conferências!');
      debugPrint('$e');
      rethrow;
    }
  }
}
