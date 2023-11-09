import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/charts/inidicator_stock.dart';

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
                        radius: 20,
                        showTitle: false),
                    PieChartSectionData(
                        value: 20,
                        color: Colors.yellow,
                        radius: 20,
                        showTitle: false),
                    PieChartSectionData(
                        value: 20,
                        color: Colors.purple,
                        radius: 20,
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
                const InidicatorStock(
                    color: Colors.purple, title: 'de consumo', value: 20),
                const InidicatorStock(
                    color: Colors.yellow, title: 'de perdas', value: 20),
                const InidicatorStock(
                    color: Colors.green, title: 'dísponivel', value: 20),
              ],
            )
          ],
        ),
      ],
    );
  }
}
