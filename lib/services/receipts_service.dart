import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/utils/enums.dart';

class ReceiptsService {
  final database = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getReceiptsByInterval(
      String restaurant_id, DateTime date_start, DateTime date_end) async {
    var start = date_start.copyWith(hour: 18, minute: 0);
    var end = date_end.copyWith(hour: 03, minute: 0, day: date_end.day + 1);
    print(restaurant_id);
    print(start);
    print(end);
    return await database
        .collection("orders")
        .orderBy("created_at")
        .where("restaurant", isEqualTo: restaurant_id)
        .where('created_at', isGreaterThanOrEqualTo: start)
        .where('created_at', isLessThanOrEqualTo: end)
        .where('status', isEqualTo: OrderStatus.delivered.name)
        .get();
  }

  Future<double> sumValuesFromCollection(
      String restaurant_id, DateTime date_start, DateTime date_end) async {
    date_start = date_start.copyWith(day: 01);

    QuerySnapshot querySnapshot =
        await getReceiptsByInterval(restaurant_id, date_start, date_end);
    double sum = 0;

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        // Verifique se o campo está presente e é um número
        var value = doc.get("value");
        if (value != null) {
          sum += double.parse(value.toString());
        }
      }
    }

    return sum;
  }

  Future<double> sumAllValuesFromRestaurants() async {
    var date_start = DateTime.now().copyWith(day: 01);

    QuerySnapshot restaurants = await database
        .collection("restaurants")
        .where("name", isNotEqualTo: "SNACKS")
        .get();

    double total = 0;

    for (var element in restaurants.docs) {
      var restaurant_id = element.id;

      QuerySnapshot querySnapshot = await getReceiptsByInterval(
          restaurant_id, date_start, DateTime.now());
      double sum = 0;

      for (var doc in querySnapshot.docs) {
        if (doc.data() != null) {
          // Verifique se o campo está presente e é um número
          var value = doc.get("value");
          if (value != null) {
            sum += double.parse(value.toString());
          }
        }
      }

      total += sum;
    }

    return total;
  }
}
