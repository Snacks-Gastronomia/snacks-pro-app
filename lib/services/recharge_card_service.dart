// import 'dart:math';

// import 'package:http/http.dart' as http;
// import 'package:snacks_pro_app/models/item_model.dart';

// class ItemsApiServices {
//   final http.Client httpClient = http.Client();
//   final List<Item> list = List.generate(
//       10,
//       (i) => Item(
//           id: 'id-$i',
//           title: 'drink $i',
//           description: "It is a long established fact that a reader"
//               "will be distracted by the readable content "
//               "of a page when looking at its layout.",
//           value: i * pi * 7,
//           restaurant_id: "teste-id",
//           image_url:
//               "https://www.dicasdemulher.com.br/wp-content/uploads/2021/04/drinks-de-morango-00.png"));

//   ItemsApiServices() {
//     list.add(Item(
//         id: 'id-x',
//         title: 'drink X',
//         description: "It is a long established fact that a reader"
//             "will be distracted by the readable content "
//             "of a page when looking at its layout.",
//         value: 52,
//         restaurant_id: "teste-id",
//         image_url: null));
//   }

//   Future<void> postItem(Item item) async {
//     //     final Uri uri = Uri(
//     //   scheme: 'https',
//     //   host: kApiHost,
//     //   path: '/data/2.5/weather',
//     //   queryParameters: {
//     //     'lat': '${directGeocoding.lat}',
//     //     'lon': '${directGeocoding.lon}',
//     //     'units': kUnit,
//     //     'appid': dotenv.env['APPID'],
//     //   },
//     // );
//   }
//   Future<List<Item>> getPopularItems() async {
//     return Future.delayed(
//         const Duration(milliseconds: 500), () => list.getRange(0, 5).toList());
//   }

//   Future<List<Item>> queryItems(String query, String? category) async {
//     return Future.delayed(const Duration(milliseconds: 500),
//         () => list.where((element) => element.title.contains(query)).toList());
//   }

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
// }
