import 'dart:convert';

import 'package:crypto/crypto.dart';

class AppMD5 {
  bool checkIfValidMD5Hash(String str) {
    RegExp regexExp = RegExp(r"^[0-9a-fA-F]{32}$");

    return regexExp.hasMatch(str);
  }

  String getEncrypt(String value) {
    var key = utf8.encode('p@25af3208#edf.,79758b=b]351dc02c6e5b');
    var bytes = utf8.encode(value);

    var hmacSha256 = Hmac(md5, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }
}
