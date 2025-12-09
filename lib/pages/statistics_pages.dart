import 'package:flutter/material.dart';
import '../services/stats_repository.dart';
import '../widgets/stat_kpi_card.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/priority_bar_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late final StatsRepository repo;

  @override
  void initState() {
    super.initState();
    repo = StatsRepository(); // later inject real API
  }

  @override
  Widget build(BuildContext context) {
    final budgetMax = repo.budgetMax;
    final spend = repo.spend;
    final remaining = (budgetMax - spend).clamp(0, double.infinity);
    final progress = repo.purchaseProgress;
    final credits = repo.walletCredits;
    final debits = repo.walletDebits;
    final balance = repo.walletBalance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistique'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // KPI cards
            Row(
              children: [
                Expanded(
                  child: StatKpiCard(
                    title: 'Budget Max',
                    value: '${budgetMax.toStringAsFixed(2)}',
                    color: Colors.blue,
                    icon: Icons.savings,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatKpiCard(
                    title: 'Dépenses',
                    value: '${spend.toStringAsFixed(2)}',
                    color: Colors.orange,
                    icon: Icons.shopping_cart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatKpiCard(
                    title: 'Restant',
                    value: '${remaining.toStringAsFixed(2)}',
                    color: Colors.green,
                    icon: Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatKpiCard(
                    title: 'Progression achats',
                    value: '${progress.toStringAsFixed(0)}%',
                    color: Colors.purple,
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Charts
            CategoryPieChart(data: repo.totalByCategory),
            const SizedBox(height: 16),
            PriorityBarChart(data: repo.countByPriority),
            const SizedBox(height: 16),

            // Wallet summary
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Portefeuille',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatKpiCard(
                            title: 'Crédits',
                            value: '${credits.toStringAsFixed(2)}',
                            color: Colors.teal,
                            icon: Icons.arrow_downward,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatKpiCard(
                            title: 'Débits',
                            value: '${debits.toStringAsFixed(2)}',
                            color: Colors.red,
                            icon: Icons.arrow_upward,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    StatKpiCard(
                      title: 'Solde',
                      value: '${balance.toStringAsFixed(2)}',
                      color: Colors.indigo,
                      icon: Icons.account_balance,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
