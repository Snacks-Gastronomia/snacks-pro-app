import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
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
  final fs = FirebaseStorage.instance.ref();
  MenuCubit() : super(MenuState.initial());

  void changeImage(String? value) {
    print(value);
    final item = state.item;

    emit(state.copyWith(item: item.copyWith(image_url: value)));
  }

  void removeImage() {
    final item = state.item;

    emit(state.copyWith(item: item.copyWith(image_url: "")));
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

  void changeTitle(String value) {
    final item = state.item;
    emit(state.copyWith(item: item.copyWith(title: value)));
  }

  void addExtraItem(String title, dynamic value) {
    final item = state.item;
    var el = {
      "id": state.item.extra.length + 1,
      "title": title,
      "value": value.toString()
    };

    emit(state.copyWith(item: item.copyWith(extra: [...item.extra, el])));
  }

  void addOptionToItem(String title, dynamic value) {
    final item = state.item;
    var el = {
      "id": state.item.options.length + 1,
      "title": title,
      "value": value.toString()
    };

    emit(state.copyWith(
        item: item.copyWith(options: [...item.options, el].toList())));
    print(state.item.options);
  }

  void removeExtraItem(id) {
    var extras = List.from(state.item.extra);

    extras.removeWhere((element) => element["id"] == id);

    emit(state.copyWith(item: state.item.copyWith(extra: extras)));
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
    emit(state.copyWith(item: item.copyWith(time: int.parse(value))));
  }

  itemSelected() {
    return state.item.ingredients
        .singleWhere((element) => element.name == state.selected);
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

      var restaurant_id = data["restaurant"]["id"];

      emit(state.copyWith(
          item: state.item.copyWith(restaurant_id: restaurant_id)));
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
}
