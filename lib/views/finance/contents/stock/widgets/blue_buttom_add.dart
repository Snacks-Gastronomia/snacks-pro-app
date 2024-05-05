import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/utils/modal.dart';

class BlueButtomAdd extends StatelessWidget {
  const BlueButtomAdd({super.key, required this.label, required this.action});

  final String label;
  final Function action;

  @override
  Widget build(BuildContext context) {
    final modal = AppModal();
    return GestureDetector(
      onTap: () => action(),
      child: DottedBorder(
        radius: const Radius.circular(20),
        color: Colors.blue,
        child: Container(
            width: 180,
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            )),
      ),
    );
  }
}
