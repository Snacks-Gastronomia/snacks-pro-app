import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/services/firebase/database.dart';
import 'package:snacks_pro_app/services/orders_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/printer.dart';
import 'package:snacks_pro_app/utils/snackbar.dart';
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
  final auth = FirebaseAuth.instance;
  final appPrinter = AppPrinter();
  // final StreamController<QuerySnapshot> fetchItemsController =
  //     StreamController();
  final ItemsRepository itemsRepository =
      ItemsRepository(services: ItemsApiServices());

  final FinanceRepository financeRepository =
      FinanceRepository(services: FinanceApiServices());

  final OrdersRepository ordersRepository = OrdersRepository();

  HomeCubit() : super(HomeState.initial()) {
    saveStorage();
    fetchItems();
    print("user logged: ${auth.currentUser!.uid}");
  }

  Future<void> saveStorage() async {
    print("init storage");
    var stor = await storage.getDataStorage("user");
    emit(state.copyWith(storage: stor));
    print("finish storage");
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchOrders() {
    if (state.storage["access_level"] == AppPermission.cashier.name) {
      return ordersRepository.fetchOrdersByStatus(OrderStatus.done);
    }
    return ordersRepository
        .fetchOrdersByRestaurantId(state.storage["restaurant"]["id"]);
  }

  Future<String> getProfileData() async {
    return "";
  }

  // Future<dynamic> getOrderByItemId(String id) async {}

  void printerOrder(data, context) async {
    var toast = AppToast();
    toast.init(context: context);
    // debugPrint(data.toString());
    List<dynamic> items = data["items"] ?? [];
    List<OrderModel> orders = items.map((e) => OrderModel.fromMap(e)).toList();

    var id = state.storage["restaurant"]["id"];
    var printer = await financeRepository.getPrinterByGoal(id, "Pedidos");

    if (printer.docs.isEmpty) {
      // print("impressora não cadastrada");
      toast.showToast(
          context: context,
          content: "Impressora não cadastrada",
          type: ToastType.error);
    } else {
      toast.showToast(
          context: context,
          content: "imprimindo pedido...",
          type: ToastType.info);
      print(printer.docs[0].get("ip"));
      appPrinter.printOrders(context, printer.docs[0].get("ip"), orders);
    }
  }

  void fetchItems() async {
    if (!state.listIsLastPage) {
      var data = await storage.getDataStorage("user");
      var id = data["restaurant"]["id"];
      emit(state.copyWith(status: AppStatus.loading));
      itemsRepository
          .fetchItems(id, state.lastDocument)
          .distinct()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          // print("fetch...");
          var data = event.docs.map<Map<String, dynamic>>((e) {
            var el = e.data();
            el.addAll({"id": e.id});
            return el;
          }).toList();
          emit(state.copyWith(
              lastDocument: event.docs.last, menu: [...state.menu, ...data]));
        } else {
          emit(state.copyWith(listIsLastPage: true));
        }
        emit(state.copyWith(status: AppStatus.loaded));
      });
    }
  }

  Future<void> fetchQuery(String query) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      itemsRepository
          .searchQuery(query, state.category, state.storage["restaurant"]["id"])
          .listen((event) {
        if (event.docs.isNotEmpty) {
          emit(state.copyWith(
              menu: event.docs.map<Map<String, dynamic>>((e) {
            var el = e.data();
            el.addAll({"id": e.id});
            return el;
          }).toList()));
        }
        emit(state.copyWith(
          status: AppStatus.loaded,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.error,
        error: e.toString(),
      ));
      print('state: $e');
    }
  }

  void disableItem(String docID, bool value) async {
    await fb.updateDocumentToCollectionById(
        collection: "menu", id: docID, data: {"active": value});
  }

  void updateCategory(String category) {
    emit(state.copyWith(category: category));
    fetchItems();
  }

  void changeQuery(String value) {
    emit(state.copyWith(query: value));
    // fetchItems();
  }
}
