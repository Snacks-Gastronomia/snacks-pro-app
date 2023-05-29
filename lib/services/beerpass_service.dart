import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class BeerPassService {
  final http.Client httpClient = http.Client();
  static const URL = "us-central1-beerpass-1500423500833.cloudfunctions.net";

  Future<dynamic> createOrder(data, double value, String method) async {
    try {
      var header = await getReqHeader();

      var alreadyExist = await getCard(null, data["cpf"]);

      if (alreadyExist != null) {
        var res = await updateOrder(
            id: alreadyExist["id"],
            newRfid: data["rfid"],
            cpf: alreadyExist["cpf"]);

        if (res != null) {
          return res.body;
        }
      } else {
        var response = await httpClient.post(Uri.https(URL, "apiv2/comandas"),
            body: jsonEncode(data), headers: header);
        if (response.statusCode != 200) {
          return jsonDecode(response.body);
        }
      }

      return await rechargeCard(data["rfid"], value, method);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, String>> getReqHeader() async {
    return {
      "Authorization": await getToken() ?? "",
      "Content-Type": "application/json",
    };
  }

  Future<String?> getToken() async {
    try {
      await Hive.initFlutter();

      Box box = await Hive.openBox('token');

      box = await Hive.openBox('token');
      var token = box.get('value');

      if (token == null || JwtDecoder.isExpired(token)) {
        var response = await httpClient.get(Uri.https(
            URL,
            "apiv2/autenticacao/obter-token",
            {"usuario": "beersnack", "senha": r"$@BeeSnckhsa2023"}));

        token = jsonDecode(response.body)["token"];

        box.put('value', token);
      }
      // if (box.isOpen) {
      //box.close();
      // }
      return token;
    } catch (e) {
      print(e);
    }
  }

  Future closeCard(Map<String, dynamic> data) async {
    var header = await getReqHeader();
    var response = await httpClient.post(
        Uri.https(URL, "apiv2/comandas/remover"),
        body: jsonEncode(data),
        headers: header);

    if (response.statusCode != 200) {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> getCard(String? rfid, String? cpf) async {
    try {
      var queryParans = {"rfid": rfid, "cpf": cpf};

      final params = Map.fromEntries(
          queryParans.entries.where((element) => element.value != null));

      var header = await getReqHeader();

      var response = await httpClient.get(
        Uri.https(URL, "apiv2/comandas", params),
        headers: header,
      );
      if (response.statusCode == 200) {
        var body = List.from(jsonDecode(response.body));

        return body.isNotEmpty ? body[0] : null;
      }
    } catch (e) {
      print(e);
    }
  }

  parseDate(String dateStr) =>
      DateFormat("y-M-d").format(DateFormat('d/M/y').parse(dateStr));

  Future<List<dynamic>> fetchRecharges(
      {required String paymentType,
      required int day,
      required int month}) async {
    var header = await getReqHeader();

    var now = DateTime.now();

    var startAt = parseDate('$day/$month/${now.year}');
    var endAt = parseDate('${day + 1}/$month/${now.year}');

    var filter = {
      "inicio": startAt,
      "fim": endAt,
      if (paymentType.isNotEmpty) "tipoPagamento": paymentType
    };

    var response = await httpClient
        .get(Uri.https(URL, 'apiv2/recargas', filter), headers: header);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
    }
    return [];
  }

  Future<dynamic> rechargeCard(rfid, double valor, String method) async {
    var data = {
      "rfid": rfid,
      "tipoPagamento": method,
      "valor": valor,
    };
    var header = await getReqHeader();
    var response = await httpClient.post(
        Uri.https(URL, "apiv2/comandas/recarregar"),
        body: jsonEncode(data),
        headers: header);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> updateOrder(
      {required String id,
      required String newRfid,
      required String cpf}) async {
    var data = {"rfid": newRfid, "cpf": cpf, "comandaAberta": true};
    var header = await getReqHeader();
    var response = await httpClient.put(Uri.https(URL, "apiv2/comandas/$id"),
        body: jsonEncode(data), headers: header);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
    } else {
      return response.body;
    }
  }
}
