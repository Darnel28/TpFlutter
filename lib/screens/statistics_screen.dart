import 'package:flutter/material.dart';
import 'package:projetgroupe/database/database_helper.dart';
import 'package:projetgroupe/models/transaction.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Transaction> _allTransactions = [];
  double _totalExpenses = 0.0;
  double _totalRecharges = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final balance = await _dbHelper.getBalance();
    
    // Pour cet exemple, nous allons simuler des données
    // Dans une application réelle, vous récupéreriez toutes les transactions
    _allTransactions = [
      Transaction(
        amount: 178.50,
        description: 'Courses du 08/12',
        date: DateTime(2024, 12, 8),
        type: 'depense',
      ),
      Transaction(
        amount: 210.25,
        description: 'Courses',
        date: DateTime(2024, 12, 1),
        type: 'depense',
      ),
      Transaction(
        amount: 100.00,
        description: 'Rechargement',
        date: DateTime(2024, 11, 25),
        type: 'recharge',
      ),
    ];

    _totalExpenses = _allTransactions
        .where((t) => t.type == 'depense')
        .fold(0.0, (sum, t) => sum + t.amount);

    _totalRecharges = _allTransactions
        .where((t) => t.type == 'recharge')
        .fold(0.0, (sum, t) => sum + t.amount);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Résumé statistique
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.bar_chart,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Vue d\'ensemble',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(
                          label: 'Dépenses totales',
                          value: '${_totalExpenses.toStringAsFixed(2)}€',
                          color: Colors.red,
                        ),
                        _StatItem(
                          label: 'Recharges totales',
                          value: '${_totalRecharges.toStringAsFixed(2)}€',
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Historique détaillé
            const Text(
              'Historique des transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _allTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = _allTransactions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        transaction.type == 'depense'
                            ? Icons.shopping_cart
                            : Icons.account_balance_wallet,
                        color: transaction.type == 'depense'
                            ? Colors.red
                            : Colors.green,
                      ),
                      title: Text(transaction.description),
                      subtitle: Text(
                        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                      ),
                      trailing: Text(
                        '${transaction.type == 'depense' ? '-' : '+'}${transaction.amount.toStringAsFixed(2)}€',
                        style: TextStyle(
                          color: transaction.type == 'depense'
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Graphique (placeholder)
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Évolution des dépenses',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.show_chart,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Graphique des dépenses',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}