import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/charts/indicator_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';

class StockPieChart extends StatelessWidget {
  const StockPieChart({Key? key, required this.item});
  final ItemStock item;

  @override
  Widget build(BuildContext context) {
    final available =
        ((item.amount - (item.losses ?? 0) - (item.consume ?? 0)) /
                item.amount) *
            100;

    final losses = ((item.losses ?? 0) / item.amount) * 100;
    final consume = ((item.consume ?? 0) / item.amount) * 100;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100, // Largura fixa para o PieChart
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                        value: available,
                        color: Colors.green,
                        radius: 15,
                        showTitle: false),
                    PieChartSectionData(
                        value: losses,
                        color: Colors.yellow,
                        radius: 15,
                        showTitle: false),
                    PieChartSectionData(
                        value: consume,
                        color: Colors.purple,
                        radius: 15,
                        showTitle: false)
                  ],
                ),
                swapAnimationDuration: Duration(milliseconds: 300),
                swapAnimationCurve: Curves.linear,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Column(
              children: [
                IndicatorStock(
                    color: Colors.purple,
                    title: 'de consumo',
                    value: consume.toInt()),
                IndicatorStock(
                    color: Colors.yellow,
                    title: 'de perdas',
                    value: losses.toInt()),
                IndicatorStock(
                    color: Colors.green,
                    title: 'dísponivel',
                    value: available.toInt()),
              ],
            )
          ],
        ),
      ],
    );
  }
}
