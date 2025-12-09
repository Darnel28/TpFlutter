import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final colors = [
      Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal,
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Répartition par catégorie',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: PieChart(PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: List.generate(entries.length, (i) {
                  final e = entries[i];
                  final total = data.values.fold(0.0, (s, v) => s + v);
                  final pct = total == 0 ? 0 : (e.value / total) * 100;
                  return PieChartSectionData(
                    color: colors[i % colors.length],
                    value: e.value,
                    title: '${pct.toStringAsFixed(0)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,
                    ),
                  );
                }),
              )),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: List.generate(entries.length, (i) {
                final e = entries[i];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length], borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('${e.key} (${e.value.toStringAsFixed(2)})',
                        style: const TextStyle(fontSize: 12)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
