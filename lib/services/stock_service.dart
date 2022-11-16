// import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/firebase/database.dart';

class StockItem {
  final String? id;
  final String title;
  final int amount;
  final double unique_volume;
  final String unit;
  StockItem({
    this.id,
    required this.title,
    required this.amount,
    required this.unique_volume,
    required this.unit,
  });
}

class StockApiServices {
  final database = FirebaseDataBase();
  final http.Client httpClient = http.Client();
  final List categories = ["Bebidas", "Pizzas", "Comida japonesa", "Fast-food"];

  final List<StockItem> stock = List.generate(
    10,
    (i) => StockItem(
      id: '$i',
      amount: i + 10,
      title: "$i vodka",
      unique_volume: 800,
      unit: "ml",
    ),
  );

  Future<void> postItem(Item item) async {
    try {
      await database.createDocumentToCollection(
          collection: "menu", data: item.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> getStockItems() async {
    return Future.delayed(const Duration(milliseconds: 500), () => stock);
  }

  Future<List<dynamic>> getCategories() async {
    return Future.delayed(const Duration(milliseconds: 500), () => categories);
  }

  Future<List<dynamic>> getStockItemsByQuery(String query) async {
    return Future.delayed(const Duration(milliseconds: 500),
        () => stock.where((element) => element.title.contains(query)).toList());
  }

//   Future<List<Item>> getItems(String? category) async {
//     try {
//       // final http.Response response = await httpClient.get(uri);

//       // if (response.statusCode != 200) {
//       //   throw httpErrorHandler(response);
//       // }

//       // final responseBody = json.decode(response.body);

//       // if (responseBody.isEmpty) {
//       //   throw WeatherException('Cannot get the location of $city');
//       // }

//       // final directGeocoding = DirectGeocoding.fromJson(responseBody);

//       return Future.delayed(const Duration(milliseconds: 500), () => list);
//     } catch (e) {
//       rethrow;
//     }
//   }
}
