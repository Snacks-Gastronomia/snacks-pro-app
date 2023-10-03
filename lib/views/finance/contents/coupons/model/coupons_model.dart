class CouponsModel {
  bool active;
  String code;
  int discount;
  CouponsModel({
    required this.active,
    required this.code,
    required this.discount,
  });

  factory CouponsModel.fromMap(Map<String, dynamic> map) {
    return CouponsModel(
      active: map['active'],
      code: map['code'],
      discount: map['discount'],
    );
  }

  static List<CouponsModel> fromData(List data) {
    return data.map((doc) => CouponsModel.fromMap(doc.data())).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "active": active,
      "code": code,
      "discount": discount,
    };
  }
}
