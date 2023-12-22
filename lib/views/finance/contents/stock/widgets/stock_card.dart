import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/item_details_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/consume_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.item,
  });

  final ItemStock item;

  @override
  Widget build(BuildContext context) {
    final double rest = item.amount - (item.losses ?? 0) - (item.consume ?? 0);

    double valuePercent = rest / item.amount;
    int percent = (valuePercent * 100).toInt();

    final stock = NewStockService();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => FutureBuilder(
              future: stock.getConsume(item),
              builder: (context, future) {
                if (future.hasData) {
                  return ItemDetailsStock(
                    item: item,
                    totalConsume: future.data!,
                  );
                } else {
                  return const Scaffold(
                      body: Center(child: CustomCircularProgress()));
                }
              }),
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
              trailing: Text("$percent%", style: AppTextStyles.medium(20)),
            ),
            ListTile(
              title: Text(
                "$rest/${item.amount} ${item.measure}",
                style: AppTextStyles.regular(14, color: Colors.grey),
              ),
              subtitle: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: valuePercent,
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
