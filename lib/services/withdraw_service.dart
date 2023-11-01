import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WithdrawService {
  final CollectionReference withdrawCollection =
      FirebaseFirestore.instance.collection('withdraw');

  Future<void> createWithdraw(double amount) async {
    try {
      DateTime now = DateTime.now();

      await withdrawCollection.add({
        'timestamp': now,
        'amount': amount,
      });

      debugPrint('Retirada criada com sucesso!');
    } catch (e) {
      debugPrint('Erro ao criar retirada: $e');
    }
  }

  Future<void> deleteWithdraw(DateTime timestamp) async {
    try {
      QuerySnapshot querySnapshot = await withdrawCollection
          .where('timestamp', isEqualTo: timestamp)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Existem documentos correspondentes ao timestamp
        var documentId = querySnapshot.docs.first.id;
        await withdrawCollection.doc(documentId).delete();
        debugPrint('Retirada excluída com sucesso!');
      } else {
        debugPrint('Nenhum documento correspondente ao timestamp encontrado.');
      }
    } catch (e) {
      debugPrint('Erro ao excluir retirada: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getWithdrawsByMonth() {
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth =
          DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      return withdrawCollection
          .where('timestamp', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('timestamp', isLessThanOrEqualTo: lastDayOfMonth)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return {
            'timestamp': (doc['timestamp'] as Timestamp).toDate(),
            'amount': doc['amount'],
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Erro ao obter retiradas do mês: $e');
      return Stream.value([]);
    }
  }

  Stream<int> getWithdrawCountStream() {
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth =
          DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      return withdrawCollection
          .where('timestamp', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('timestamp', isLessThanOrEqualTo: lastDayOfMonth)
          .snapshots()
          .map((snapshot) => snapshot.size);
    } catch (e) {
      debugPrint('Erro ao obter contagem de retiradas do mês: $e');
      return Stream.value(0);
    }
  }

  Stream<double> getWithdrawAmountSumStream() {
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth =
          DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      return withdrawCollection
          .where('timestamp', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('timestamp', isLessThanOrEqualTo: lastDayOfMonth)
          .snapshots()
          .map((snapshot) {
        double sum = snapshot.docs
            .map((doc) => doc['amount'] as double)
            .reduce((value, element) => value + element);
        return sum;
      });
    } catch (e) {
      debugPrint('Erro ao obter soma dos valores de retiradas do mês: $e');
      return Stream.value(0.0);
    }
  }
}
