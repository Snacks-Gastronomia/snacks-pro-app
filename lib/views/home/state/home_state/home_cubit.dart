import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/firebase/database.dart';
import 'package:snacks_pro_app/services/orders_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/home/repository/items_repository.dart';
import 'package:snacks_pro_app/services/items_service.dart';
import 'package:snacks_pro_app/views/home/repository/orders_repository.dart';

part "home_state.dart";

class HomeCubit extends Cubit<HomeState> {
  final storage = AppStorage();
  final fb = FirebaseDataBase();
  final auth = FirebaseAuth.instance;
  final ItemsRepository itemsRepository =
      ItemsRepository(services: ItemsApiServices());
  final OrdersRepository ordersRepository = OrdersRepository();

  HomeCubit() : super(HomeState.initial()) {
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

  Stream<QuerySnapshot<Object?>> fetchOrders() {
    // print("restaurant ");
    // print();
    return ordersRepository
        .fetchOrdersByRestaurantId(state.storage["companie_id"]);
  }

  Future<String> getProfileData() async {
    return "";
  }

  // Future<dynamic> getOrderByItemId(String id) async {}

  Future<Stream<QuerySnapshot<Object?>>> fetchItems() async {
    // Future fetchItems() async {
    emit(state.copyWith(status: AppStatus.loading));

    var data = await storage.getDataStorage("user");
    var id = data["restaurant"]["id"];

    return itemsRepository.fetchItems(id);
  }

  void changeItemsLoaded(List value) {
    var last_page = value.length < state.numberOfPostsPerRequest;
    emit(state.copyWith(
        status: AppStatus.loaded,
        listIsLastPage: last_page,
        listPageNumber: state.listPageNumber + 1));
  }

  Future<void> fetchQuery(String query) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final List<Item>? items =
          await itemsRepository.searchItems(query, state.category);

      emit(
          state.copyWith(search: true, status: AppStatus.loaded, items: items));

      print('state: $state');
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.error,
        error: e.toString(),
      ));
      print('state: $state');
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
}
