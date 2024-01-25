import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:snacks_pro_app/views/finance/contents/stock/charts/indicator_stock.dart';

class StockPieChart extends StatelessWidget {
  const StockPieChart({
    Key? key,
    required this.consume,
    required this.loss,
    required this.total,
  }) : super(key: key);

  final double consume;
  final double loss;
  final double total;

  @override
  Widget build(BuildContext context) {
    double available =
        total != 0 ? ((total - loss - consume) / total) * 100 : 0;
    double losses = total != 0 ? (loss / total) * 100 : 0;
    double consumed = total != 0 ? (consume / total) * 100 : 0;

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
                        color: Colors.red,
                        radius: 15,
                        showTitle: false),
                    PieChartSectionData(
                        value: consumed,
                        color: Colors.purple,
                        radius: 15,
                        showTitle: false)
                  ],
                ),
                swapAnimationDuration: const Duration(milliseconds: 300),
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
                    value: consumed.toInt()),
                IndicatorStock(
                    color: Colors.red,
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
