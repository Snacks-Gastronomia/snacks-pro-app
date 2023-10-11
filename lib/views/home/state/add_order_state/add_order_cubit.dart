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
  final repository = OrdersRepository();

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

  Future<void> makeOrder(List<OrderResponse> data) async {
    final repository = OrdersRepository();
    final mapList = data
        .map((order) => {
              'code': order.code,
              'needChange': order.needChange,
              'restaurant': order.restaurant,
              'created_at': order.created_at,
              'restaurantName': order.restaurantName,
              'isDelivery': order.isDelivery,
              'waiterPayment': order.waiterPayment,
              'rfid': order.rfid,
              'phoneNumber': order.phoneNumber,
              'waiterDelivery': order.waiterDelivery,
              'part_code': order.part_code,
              'items': order.items.map((item) => item.toMap()).toList(),
              'value': order.value,
              'paymentMethod': order.paymentMethod,
              'table': order.table,
              'receive_order': order.receiveOrder,
              'address': order.address,
              'status': order.status,
              'userUid': order.userUid,
              'customerName': order.customerName,
            })
        .toList();

    await repository.createOrder(mapList);
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
