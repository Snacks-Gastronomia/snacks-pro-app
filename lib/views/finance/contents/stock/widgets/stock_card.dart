import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class StockCard extends StatelessWidget {
  const StockCard({super.key});
  // final String title;
  // final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Column(
        children: [
          ListTile(
            title: Text("Carne Bovina", style: AppTextStyles.medium(20)),
            subtitle: Text("25/09/2023 12:00",
                style: AppTextStyles.regular(14, color: Colors.grey)),
            trailing: Text("25%", style: AppTextStyles.medium(20)),
          ),
          ListTile(
            title: Text(
              "25/100 kg",
              style: AppTextStyles.regular(14, color: Colors.grey),
            ),
            subtitle: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: 0.25,
                color: AppColors.highlight,
                backgroundColor: Colors.grey[200],
                minHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
