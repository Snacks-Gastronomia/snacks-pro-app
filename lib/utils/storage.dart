import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class AppStorage {
  //  var friends =
  final init = initStorage;
  static get initStorageHive async => await Hive.openBox('user');

  static FlutterSecureStorage get initStorage => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));
  Future<Map<String, String>> get getStorage async => await init.readAll();

  Future<Map<String, dynamic>> getDataStorage(String data) async {
    var dataStorage = await init.readAll();
    return data.isNotEmpty ? jsonDecode(dataStorage[data] ?? "") : dataStorage;
  }
}
