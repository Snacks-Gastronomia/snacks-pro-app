import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:meta/meta.dart';
import 'package:snacks_pro_app/models/ingredient_model.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/items_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';

import 'package:snacks_pro_app/services/stock_service.dart';
import 'package:snacks_pro_app/utils/md5.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/home/repository/items_repository.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/restaurant_menu/repository/stock_repository.dart';
import 'package:snacks_pro_app/views/success/success_screen.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final repository = ItemsRepository(services: ItemsApiServices());
  final storage = AppStorage.initStorage;
  final stockService = StockApiServices();
  final fs = FirebaseStorage.instance.ref();

  MenuCubit() : super(MenuState.initial());

  void changeImage(String? value) {
    print(value);
    final item = state.item;

    emit(state.copyWith(item: item.copyWith(image_url: value)));
  }

  void changeNumServed(String value) {
    final item = state.item;

    emit(state.copyWith(item: item.copyWith(num_served: int.tryParse(value))));
  }

  void removeImage() {
    final item = state.item;

    emit(state.copyWith(item: item.copyWith(image_url: "")));
  }

  void getDiscount(Item item) {
    emit(state.copyWith(discount: item.discount!.toDouble()));
  }

  Future<void> changeDiscount(Item item) async {
    var update = item.copyWith(discount: state.discount!);
    repository.updateItem(update);
    emit(state);
  }

  Future<void> removeDiscount(Item item) async {
    var update = item.copyWith(discount: 0);
    repository.updateItem(update);
    emit(state.copyWith(discount: 0));
  }

  void cancel() {
    emit(state.copyWith(discount: 0));
  }

  void incrementDiscount() {
    var discount = state.discount ?? 0;
    discount < 99 ? discount += 1 : null;

    emit(state.copyWith(discount: discount));
  }

  void decrementDiscount() {
    var discount = state.discount ?? 0;
    discount > 0 ? discount -= 1 : null;

    emit(state.copyWith(discount: discount));
  }
  // void addIngredient(String value, String unit) {
  //   final item = Ingredient(name: value, volume: 0, unit: unit);

  //   List<Ingredient> newList = List.from(state.item.ingredients);
  //   if (newList.where((element) => element.name == item.name).isEmpty) {
  //     newList.add(item);
  //   }

  //   emit(state.copyWith(item: state.item.copyWith(ingredients: newList)));
  // }

  // void changeIngredientVolume(volume) {
  //   List<Ingredient> list = List.from(state.item.ingredients);
  //   for (var element in list) {
  //     if (element.name == state.selected) {
  //       element.volume = volume;
  //     }
  //   }
  //   emit(state.copyWith(item: state.item.copyWith(ingredients: list)));
  // }

  // void removeIngredient(item) {
  //   List<Ingredient> newList = List.from(state.item.ingredients);
  //   if (itemSelected() != null) changeSelectedItem("");

  //   newList.remove(item);
  //   emit(state.copyWith(item: state.item.copyWith(ingredients: newList)));
  // }
  updateItem(Item item) {
    emit(state.copyWith(item: item, status: AppStatus.editing));
  }

  changeLimitOptions(int value) {
    emit(state.copyWith(item: state.item.copyWith(limit_extra_options: value)));
  }

  incrementLimitOptions() {
    int limit = state.item.limit_extra_options ?? 0;
    int newLimit = limit + 1;

    emit(state.copyWith(
        item: state.item.copyWith(limit_extra_options: newLimit)));
  }

  decrementLimitOptions() {
    int limit = state.item.limit_extra_options ?? 0;
    if (limit - 1 > 0) {
      emit(state.copyWith(
          item: state.item.copyWith(limit_extra_options: limit - 1)));
    }
  }

  void changeTitle(String value) {
    final item = state.item;
    emit(state.copyWith(item: item.copyWith(title: value)));
  }

  String get generateId =>
      DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();

  void addExtraItem(String title, dynamic value) {
    final item = state.item;
    var el = {"id": generateId, "title": title, "value": value.toString()};

    emit(state.copyWith(item: item.copyWith(extras: [...item.extras, el])));
  }

  void addOptionToItem(String title, dynamic value) {
    final item = state.item;
    var el = {"id": generateId, "title": title, "value": value.toString()};

    emit(state.copyWith(
        item: item.copyWith(options: [...item.options, el].toList())));
  }

  void removeExtraItem(id) {
    var extras = List.from(state.item.extras);

    extras.removeWhere((element) => element["id"] == id);

    emit(state.copyWith(item: state.item.copyWith(extras: extras)));
  }

  void removeOptionItem(id) {
    var ops = List.from(state.item.options);

    ops.removeWhere((element) => element["id"] == id);

    emit(state.copyWith(item: state.item.copyWith(options: ops)));
  }

  void changeDescription(String value) {
    final item = state.item;
    emit(state.copyWith(item: item.copyWith(description: value)));
  }

  void changePrice(String value) {
    final item = state.item;
    print(value);

    if (value.isNotEmpty) {
      emit(state.copyWith(item: item.copyWith(value: double.parse(value))));
    }
  }

  void changeCategory(String? value) {
    final item = state.item;
    emit(state.copyWith(item: item.copyWith(category: value)));
  }

  void changeMeasure(String value) {
    final item = state.item;
    emit(state.copyWith(item: item.copyWith(measure: value)));
  }

  void changeTime(String value) {
    final item = state.item;
    emit(state.copyWith(item: item.copyWith(time: int.tryParse(value) ?? 0)));
  }

  itemSelected() {
    return state.item.ingredients
        .singleWhere((element) => element == state.selected);
  }

  void changeSelectedItem(String value) {
    if (state.selected != value) {
      emit(state.copyWith(selected: value));
    } else {
      emit(state.copyWith(selected: ""));
    }
  }

  getStockItems() {}
  getCategories() {}
  fetchIngredientsByQuery(query) async {
    // return await repository.getStockItemsByQuery(query);
  }

  void saveItem(context) async {
    final encrypt = AppMD5();
    final modal = AppModal();

    var storage = AppStorage();
    if (state.status == AppStatus.editing) {
      try {
        emit(state.copyWith(status: AppStatus.loading));
        if (state.item.image_url != null) {
          var ref = fs
              .child("menu_images/${encrypt.getEncrypt(state.item.title)}.jpg");
          File file = File(state.item.image_url!);
          try {
            final snapshot = await ref.putFile(file).whenComplete(() {});
            var pathDownload = await snapshot.ref.getDownloadURL();
            emit(state.copyWith(
                item: state.item.copyWith(
              value: double.parse(state.item.options[0]["value"].toString()),
              image_url: pathDownload,
            )));
          } catch (e) {
            debugPrint(e.toString());
          }
        }

        await repository.updateItem(state.item);
        clear();
      } catch (e) {
        print(e);
      }
      Navigator.pop(context);
      modal.showIOSModalBottomSheet(
          context: context,
          content: const SuccessScreen(
              title: "Item adicionado com sucesso!", backButton: true));
    } else {
      emit(state.copyWith(status: AppStatus.loading));

      Map<String, dynamic> data = await storage.getDataStorage("user");
      // data = Map.from(jsonDecode(data["user"]));

      var restaurant = data["restaurant"];

      emit(state.copyWith(
          item: state.item.copyWith(
              restaurant_id: restaurant["id"],
              restaurant_name: restaurant["name"])));
      if (state.item.image_url != null) {
        var ref =
            fs.child("menu_images/${encrypt.getEncrypt(state.item.title)}.jpg");
        File file = File(state.item.image_url!);
        try {
          // ref.putDa;ta(data);
          final snapshot = await ref.putFile(file).whenComplete(() {});
          var pathDownload = await snapshot.ref.getDownloadURL();
          emit(state.copyWith(
              item: state.item.copyWith(
            value: double.parse(state.item.options[0]["value"].toString()),
            image_url: pathDownload,
          )));
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      //ingredients: state.ingredients

      try {
        await repository.postItem(state.item);
        clear();
      } catch (e) {
        print(e);
      }
      Navigator.pop(context);
      modal.showIOSModalBottomSheet(
          context: context,
          content: const SuccessScreen(
              title: "Item adicionado com sucesso!", backButton: true));
    }
  }

  void clear() {
    emit(state.copyWith(
        item: Item.initial(),
        selected: "",
        status: AppStatus.loaded,
        ingredients: []));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchStock() async {
    var storage = AppStorage();
    Map<String, dynamic> data = await storage.getDataStorage("user");
    // data = Map.from(jsonDecode(data["user"]));

    var restaurant = data["restaurant"]["id"];
    return stockService.fetchStockItems(restaurant);
  }

  addIngredient(ingredient, toOptions) {
    var options = List.from(state.item.options);

    options = options.map((element) {
      if ((toOptions as List).contains(element["title"])) {
        if (element["ingredients"] != null) {
          element["ingredients"] = [...element["ingredients"], ingredient];
        } else {
          element["ingredients"] = [ingredient];
        }
      }
      return element;
    }).toList();

    var item = state.item.copyWith(options: options);
    var newIng = [...state.ingredients, options];

    emit(state.copyWith(ingredients: newIng, item: item));
  }

  removeIngredient(name, op) {
    var options = List.from(state.item.options);

    options = options.map((element) {
      if (op == element["title"]) {
        var all = List.from(element["ingredients"]);

        all.removeWhere((element) => element["name"] == name);

        element["ingredients"] = all;
      }
      return element;
    }).toList();

    var item = state.item.copyWith(options: options);
    var newIng = [...state.ingredients, options];

    emit(state.copyWith(ingredients: newIng, item: item));
  }
}
