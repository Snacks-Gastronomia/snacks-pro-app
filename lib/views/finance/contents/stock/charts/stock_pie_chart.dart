import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/charts/indicator_stock.dart';

class StockPieChart extends StatelessWidget {
  const StockPieChart({Key? key});

  @override
  Widget build(BuildContext context) {
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
                        value: 40,
                        color: Colors.green,
                        radius: 15,
                        showTitle: false),
                    PieChartSectionData(
                        value: 20,
                        color: Colors.yellow,
                        radius: 15,
                        showTitle: false),
                    PieChartSectionData(
                        value: 20,
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
              children: const [
                IndicatorStock(
                    color: Colors.purple, title: 'de consumo', value: 20),
                IndicatorStock(
                    color: Colors.yellow, title: 'de perdas', value: 20),
                IndicatorStock(
                    color: Colors.green, title: 'dísponivel', value: 40),
              ],
            )
          ],
        ),
      ],
    );
  }
}
