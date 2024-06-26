import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/services/firebase/database.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/printer.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/finance/repository/finance_repository.dart';
import 'package:snacks_pro_app/views/home/repository/items_repository.dart';
import 'package:snacks_pro_app/services/items_service.dart';
import 'package:snacks_pro_app/views/home/repository/orders_repository.dart';

part "home_state.dart";

class HomeCubit extends Cubit<HomeState> {
  final storage = AppStorage();
  final fb = FirebaseDataBase();
  final appPrinter = AppPrinter();

  final auth = FirebaseAuth.instance;

  final ItemsRepository itemsRepository =
      ItemsRepository(services: ItemsApiServices());

  final FinanceRepository financeRepository =
      FinanceRepository(services: FinanceApiServices());

  final OrdersRepository ordersRepository = OrdersRepository();

  HomeCubit() : super(HomeState.initial()) {
    fetchItems();
  }

  transformRealFormat(String value) =>
      NumberFormat.currency(locale: "pt", symbol: r"R$ ")
          .format(double.parse(value));

  void printerOrder(OrderResponse data, context) async {
    var toast = AppToast();
    toast.init(context: context);

    var user = await storage.getDataStorage("user");
    var id = user["restaurant"]["id"];
    var printer = await financeRepository.getPrinterByGoal(id, "Pedidos");

    if (printer.docs.isEmpty) {
      toast.showToast(
          context: context,
          content: "Impressora não cadastrada",
          type: ToastType.error);
    } else {
      toast.showToast(
          context: context,
          content: "imprimindo pedido...",
          type: ToastType.info);

      String destination = (data.isDelivery
              ? data.receiveOrder == "address" || data.deliveryValue > 0
                  ? data.address
                  : "Ir até o local buscar o pedido"
              : data.table) ??
          "";

      appPrinter.printOrders(
          context,
          printer.docs[0].get("ip"),
          data.items,
          transformRealFormat(data.deliveryValue.toString()),
          data.isDelivery,
          destination,
          transformRealFormat(data.value.toString()),
          data.partCode,
          data.paymentMethod,
          data.customerName ?? "",
          data.phoneNumber ?? "");
    }
  }

  void fetchItems() async {
    var data = await storage.getDataStorage("user");
    var permission = data["access_level"].toString().stringToEnum;

    var id =
        permission == AppPermission.radm || permission == AppPermission.employee
            ? data["restaurant"]["id"]
            : null;

    var _stream = itemsRepository.fetchItems(id, state.lastDocument).distinct();

    emit(state.copyWith(menu: _stream));
  }

  Future<void> fetchQuery(String query) async {
    var user = await storage.getDataStorage("user");
    var permission = user["access_level"].toString().stringToEnum;

    var id =
        permission == AppPermission.radm || permission == AppPermission.employee
            ? user["restaurant"]["id"]
            : null;
    var _stream = itemsRepository.searchQuery(
        query, state.category, user["restaurant"]["id"]);

    emit(state.copyWith(menu: _stream));
  }

  void disableItem(String docID, bool value) async {
    await fb.updateDocumentToCollectionById(
        collection: "menu", id: docID, data: {"active": value});

    fetchItems();
  }

  void updateCategory(String category) {
    emit(state.copyWith(category: category));
    fetchItems();
  }

  void changeQuery(String value) {
    emit(state.copyWith(query: value));
    // fetchItems();
  }

  void removeItem(String doc, String img) async {
    await itemsRepository.deleteItem(doc, img);
    // fetchItems();
  }
}
