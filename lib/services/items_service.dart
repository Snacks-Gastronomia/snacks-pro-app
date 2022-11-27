import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/firebase/database.dart';

class ItemsApiServices {
  final http.Client httpClient = http.Client();
  final database = FirebaseFirestore.instance;
  final List<Item> list = List.generate(
      10,
      (i) => Item(
          id: 'id-$i',
          active: true,
          title: 'drink $i',
          description: "It is a long established fact that a reader"
              "will be distracted by the readable content "
              "of a page when looking at its layout.",
          value: double.parse((i * pi * 7).toStringAsFixed(3)),
          restaurant_id: "teste-id",
          time: i + 10 * 2,
          image_url:
              "https://www.dicasdemulher.com.br/wp-content/uploads/2021/04/drinks-de-morango-00.png"));

  ItemsApiServices() {
    list.add(Item(
        active: true,
        id: 'id-x',
        title: 'drink X',
        description: "It is a long established fact that a reader"
            "will be distracted by the readable content "
            "of a page when looking at its layout.",
        value: 52,
        time: 30,
        restaurant_id: "teste-id",
        image_url: null));
  }

  Future<void> postItem(Item item) async {
    //     final Uri uri = Uri(
    //   scheme: 'https',
    //   host: kApiHost,
    //   path: '/data/2.5/weather',
    //   queryParameters: {
    //     'lat': '${directGeocoding.lat}',
    //     'lon': '${directGeocoding.lon}',
    //     'units': kUnit,
    //     'appid': dotenv.env['APPID'],
    //   },
    // );
  }
  Future<Item> getSingleItem(String id) async {
    //     final Uri uri = Uri(
    //   scheme: 'https',
    //   host: kApiHost,
    //   path: '/data/2.5/weather',
    //   queryParameters: {
    //     'lat': '${directGeocoding.lat}',
    //     'lon': '${directGeocoding.lon}',
    //     'units': kUnit,
    //     'appid': dotenv.env['APPID'],
    //   },
    // );

    return Future.delayed(const Duration(milliseconds: 500),
        () => list.firstWhere((element) => element.id == id));
  }

  Future<List<Item>> getPopularItems() async {
    return Future.delayed(
        const Duration(milliseconds: 500), () => list.getRange(0, 5).toList());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> queryItems(
      String query, String? category, restaurant_id) async {
    return database
        .collection("menu")
        .where("restaurant_id", isEqualTo: restaurant_id)
        // .where("category", isEqualTo: category)
        .startAt([query]).endAt(["$query\uf8ff"]).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getItems(
      String? restaurant_id, String query) {
    try {
      return database
          .collection("menu")
          .where("restaurant_id", isEqualTo: restaurant_id)
          .limit(5)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }
}
