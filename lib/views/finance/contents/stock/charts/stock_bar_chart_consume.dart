import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StockBarChartConsume extends StatelessWidget {
  final List<Map> dataBarChart;
  const StockBarChartConsume({super.key, required this.dataBarChart});

  @override
  Widget build(BuildContext context) {
    var consume = dataBarChart.isNotEmpty ? dataBarChart[0]['consume'] : 0;
    double maxY = consume != 0
        ? double.parse(((consume * dataBarChart[0]['amount']) +
                (dataBarChart[0]['consume'] / 2))
            .toString())
        : 100;
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      default:
        text = dataBarChart[value.toInt()]['month'];
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: dataBarChart.isNotEmpty
                  ? dataBarChart[0]['consume'] / 5
                  : 30),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.black,
          Colors.black,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups =>
      dataBarChart.asMap().entries.map((e) {
        final index = e.key;
        final element = e.value;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: double.parse(
                  (element['consume'] * element['amount']).toString()),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        );
      }).toList();
}
