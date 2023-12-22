import 'package:flutter/material.dart';

class CommonButtonStock extends StatelessWidget {
  const CommonButtonStock(
      {super.key,
      required this.label,
      required this.icon,
      this.color,
      this.textColor,
      required this.action});
  final String label;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          fixedSize: const Size(double.maxFinite, 59)),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(color: textColor ?? Colors.black),
        ),
        trailing: Icon(
          icon,
          color: textColor,
        ),
      ),
    );
  }
}
