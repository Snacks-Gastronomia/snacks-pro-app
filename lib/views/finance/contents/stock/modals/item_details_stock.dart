import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/charts/stock_pie_chart.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/items_stock.dart';

class ItemDetailsStock extends StatelessWidget {
  const ItemDetailsStock({super.key, required this.item});
  final ItemsStock item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(
                  width: 30,
                ),
                Text(item.title, style: AppTextStyles.regular(22))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Entradas",
              style: AppTextStyles.bold(22),
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: ListTile(
                            title: const Text('Valor'),
                            subtitle: Text(NumberFormat.currency(
                                    locale: "pt", symbol: r"R$ ")
                                .format(item.value)),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                              title: const Text('Quantidade'),
                              subtitle: Text('${item.amount} ${item.measure}')),
                        ),
                      ],
                    ),
                    ListTile(
                      title: const Text('Documento'),
                      subtitle: Text('${item.document}'),
                    ),
                    ListTile(
                      title: const Text('Descrição'),
                      subtitle: Text(item.description),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            StockPieChart()
          ],
        ),
      ),
    );
  }
}
