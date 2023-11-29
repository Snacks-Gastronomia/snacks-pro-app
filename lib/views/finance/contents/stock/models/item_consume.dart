import 'dart:convert';

class ItemConsume {
  String title;
  int consume;
  ItemConsume({
    required this.title,
    required this.consume,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'consume': consume,
    };
  }

  factory ItemConsume.fromMap(Map<String, dynamic> map) {
    return ItemConsume(
      title: map['title'] as String,
      consume: map['consume'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemConsume.fromJson(String source) =>
      ItemConsume.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<ItemConsume> fromList(List list) {
    return list.map((map) => ItemConsume.fromMap(map)).toList();
  }
}
