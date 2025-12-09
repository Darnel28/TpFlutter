import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriorityBarChart extends StatelessWidget {
  final Map<String, int> data;

  const PriorityBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final keys = ['Faible', 'Moyenne', 'Haute', 'Urgent'];
    final colors = {
      'Faible': Colors.blue,
      'Moyenne': Colors.green,
      'Haute': Colors.orange,
      'Urgent': Colors.red,
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Articles par priorité',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= keys.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(keys[idx], style: const TextStyle(fontSize: 11)),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(keys.length, (i) {
                  final k = keys[i];
                  final v = data[k] ?? 0;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: v.toDouble(),
                        color: colors[k],
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
