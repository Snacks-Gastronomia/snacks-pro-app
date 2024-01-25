import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/consume_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    Key? key,
    required this.created_at,
    required this.title,
    required this.unit,
    required this.used,
    required this.total,
    required this.onTap,
  }) : super(key: key);

  final DateTime created_at;
  final String title;
  final String unit;
  final double used;
  final double total;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double fractionPercente = (used / total);
    double percent = fractionPercente * 100;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Column(
          children: [
            ListTile(
              title: Text(title, style: AppTextStyles.medium(20)),
              subtitle: Text(DateFormat("d/MM/y H:m").format(created_at),
                  style: AppTextStyles.light(10, color: Colors.grey)),
              trailing: Text("${percent.toStringAsFixed(2)}%",
                  style: AppTextStyles.medium(20)),
            ),
            ListTile(
              title: Text(
                "$used/$total $unit",
                style: AppTextStyles.regular(14, color: Colors.grey),
              ),
              subtitle: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: fractionPercente,
                  color: AppColors.highlight,
                  backgroundColor: Colors.grey[200],
                  minHeight: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
