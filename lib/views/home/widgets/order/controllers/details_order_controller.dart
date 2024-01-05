import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/conference/controllers/conference_controller.dart';
import 'package:snacks_pro_app/views/conference/modals/modal_conference.dart';

class DetailsOrderController {
  final AppModal modal = AppModal();
  final TextEditingController valueOrderConfimate = TextEditingController();
  final ConferenceController conferenceController = ConferenceController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var refence = FirebaseFirestore.instance.collection('orders');

  void showModalConfimateOrder(context, partCode) {
    modal.showModalBottomSheet(
      context: context,
      content: ModalConference(
        title: 'Confirmar Pedido',
        subtitle: 'Valor correspondente ao total do pedido',
        textEditingController: valueOrderConfimate,
        onTap: () {
          confirmateOrder(partCode);
          Navigator.pop(context);
        },
      ),
    );
  }

  void confirmateOrder(partCode) async {
    try {
      QuerySnapshot<Map<String, dynamic>> order =
          await refence.where('part_code', isEqualTo: partCode).get();
      OrderResponse orderResponse =
          OrderResponse.fromFirebase(order.docs.first);
      debugPrint("confirmateOrder sucess!!");

      // debugPrint(orderResponse.toMap().toString());
      // debugPrint(orderResponse.copyWith(confirmed: true).toMap().toString());

      refence
          .doc(orderResponse.id)
          .update(orderResponse.copyWith(confirmed: true).toMap());
    } catch (e) {
      debugPrint('erro confirmateOrder: $e');
    }
  }
}
