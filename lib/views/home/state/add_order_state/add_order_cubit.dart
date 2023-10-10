import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/home/repository/orders_repository.dart';

import 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit() : super(AddOrderState.inital());
  double subtotal = 0;
  double delivery = 7;
  double total = 0;
  double deliveryValue = 0;

  var toast = AppToast();

  final firestore = FirebaseFirestore.instance;

  Future<void> getDeliveryValue() async {
    try {
      var collectionRef = FirebaseFirestore.instance
          .collection("snacks_config")
          .doc("features")
          .collection("all");

      var querySnapshot = await collectionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var document in querySnapshot.docs) {
          var data = document.data();

          deliveryValue = (data["value"] is int)
              ? (data["value"] as int).toDouble()
              : data["value"] as double;
          print(data);
        }
      } else {
        print('A coleção está vazia.');
      }
    } catch (e) {
      print('Erro ao obter dados: $e');
    }
  }

  Future<void> makeOrder(String method,
      {String? rfid = "", String change = ""}) async {
    final repository = OrdersRepository();
    var data;

    await repository.createOrder(data);

    // await cardRepository.doPayment(rfid, state.total);
  }

  void handleCheckboxValue(bool value) {
    value ? delivery = deliveryValue : delivery = 0;
    updateTotal();
  }

  void updateTotal() {
    total = subtotal + delivery;
  }

  void removeItem(List<ItemResponse> itemResponse, index, amount) {
    subtotal -= (itemResponse[index].item.value * amount);
    updateTotal();
    itemResponse.removeAt(index);
  }

  void incrementAmount(ItemResponse itemResponse, amount) {
    subtotal += itemResponse.item.value;

    amount += 1;
    itemResponse.amount = amount;

    updateTotal();
  }

  void decrementAmount(ItemResponse itemResponse, amount) {
    subtotal -= itemResponse.item.value;

    amount -= 1;
    itemResponse.amount = amount;

    updateTotal();
  }

  void showToastSucess(context) {
    toast.init(context: context);

    toast.showToast(
        context: context,
        content: "Pedido adicionado com sucesso",
        type: ToastType.success);
  }
}
