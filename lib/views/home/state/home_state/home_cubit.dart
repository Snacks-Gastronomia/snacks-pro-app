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
    fetchItems();
    saveStorage();
    print("user logged: ${auth.currentUser!.uid}");
  }

  Future<void> saveStorage() async {
    print("init storage");

    // emit(state.copyWith(status: AppStatus.loading));

    emit(state.copyWith(
        storage: Map.from(await storage.getDataStorage("user"))));
    print("finish storage");
  }

  // Future<void> fetchMoreItems() async {
  //   try {
  //     emit(state.copyWith(status: AppStatus.loading));
  //     final List<Item>? data = await itemsRepository.fetchItems(state.category);
  //     final items = [...state.items, ...data!.toList()];

  //     var last_page = data.length < state.numberOfPostsPerRequest;
  //     emit(state.copyWith(
  //         status: AppStatus.loaded,
  //         items: items,
  //         listIsLastPage: last_page,
  //         listPageNumber: state.listPageNumber + 1));
  //   } catch (e) {
  //     debugPrint("error");
  //     emit(state.copyWith(status: AppStatus.error));
  //   }
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchOrders() {
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
    List<Order> orders = items.map((e) => Order.fromMap(e)).toList();

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
      appPrinter.printOrders(printer.docs[0].get("ip"), orders);
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

  // void fetchMoreItems() async {
  //   emit(state.copyWith(status: AppStatus.loading));
  //   var menu = state.menu;
  //   var dataStorage = await storage.getDataStorage("user");
  //   var id = dataStorage["restaurant"]["id"];

  //   var data = await itemsRepository.fetchMoreItems(id, state.lastDocument!);

  //   var list = data.docs.map((e) => e.data()).toList();
  //   // .listen((event) {
  //   //   if (event.docs.isNotEmpty) {
  //   //     var data = event.docs.map<Map<String, dynamic>>((e) {
  //   //       var el = e.data();
  //   //       el.addAll({"id": e.id});
  //   //       return el;
  //   //     }).toList();

  //   //     // bool last_page = data.length < state.numberOfPostsPerRequest;
  //   // print(list.length);
  //   if (list.isNotEmpty) {
  //     emit(state.copyWith(
  //         status: AppStatus.loaded,
  //         menu: [...menu, ...list],
  //         lastDocument: data.docs.last));
  //   }

  //   // });
  // }
  // void fetchMoreItems() async {
  //   emit(state.copyWith(status: AppStatus.loading));

  //   var data = await storage.getDataStorage("user");
  //   var id = data["restaurant"]["id"];

  //   itemsRepository.fetchItems(id).listen((event) {
  //     if (event.docs.isNotEmpty) {
  //       var data = event.docs.map<Map<String, dynamic>>((e) {
  //         var el = e.data();
  //         el.addAll({"id": e.id});
  //         return el;
  //       }).toList();
  //       bool last_page = data.length < state.numberOfPostsPerRequest;
  //       emit(state.copyWith(
  //           status: AppStatus.loaded,
  //           menu: data,
  //           listIsLastPage: last_page,
  //           listPageNumber: state.listPageNumber + 1));
  //     }
  //   });
  // }

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
