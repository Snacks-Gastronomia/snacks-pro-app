class CouponsModel {
  bool active;
  String code;
  int discount;
  CouponsModel({
    required this.active,
    required this.code,
    required this.discount,
  });

  Map<String, dynamic> toMap() {
    return {
      "active": active,
      "code": code,
      "discount": discount,
    };
  }
}
