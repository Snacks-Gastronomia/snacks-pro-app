import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/item_details_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/items_stock.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.item,
  });

  final ItemsStock item;

  @override
  Widget build(BuildContext context) {
    final double rest = item.amount - (item.losses ?? 0);
    final modal = AppModal();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ItemDetailsStock(
            item: item,
          ),
        ),
      ),
      child: Card(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Column(
          children: [
            ListTile(
              title: Text(item.title, style: AppTextStyles.medium(20)),
              subtitle: Text(DateFormat("d/M/y").format(item.dateTime),
                  style: AppTextStyles.regular(14, color: Colors.grey)),
              trailing: Text("25%", style: AppTextStyles.medium(20)),
            ),
            ListTile(
              title: Text(
                "$rest/${item.amount} kg",
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
      ),
    );
  }
}
