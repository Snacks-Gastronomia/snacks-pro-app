import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IndicatorStock extends StatelessWidget {
  const IndicatorStock(
      {super.key,
      required this.color,
      required this.title,
      required this.value});
  final MaterialColor color;
  final String title;
  final int value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 150,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            color: Color(color.value),
          ),
          const SizedBox(
            width: 10,
          ),
          Text("$value% $title"),
        ],
      ),
    );
  }
}
