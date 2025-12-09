import 'package:flutter/material.dart';
import 'package:projetgroupe/database/database_helper.dart';
import 'package:projetgroupe/models/transaction.dart' as my_models;

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  double _balance = 0.0;
  List<my_models.Transaction> _transactions = []; // Utilisez ExpenseTransaction
  final TextEditingController _expenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _balance = await _dbHelper.getBalance();
    _transactions = await _dbHelper.getTransactions(); 
    setState(() {});
  }

  Future<void> _rechargeWallet() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recharger le portefeuille'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('50€'),
              onTap: () => _processRecharge(50),
            ),
            ListTile(
              title: const Text('100€'),
              onTap: () => _processRecharge(100),
            ),
            ListTile(
              title: const Text('200€'),
              onTap: () => _processRecharge(200),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processRecharge(double amount) async {
    await _dbHelper.rechargeBalance(amount);
    Navigator.pop(context);
    await _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('+${amount}€ ajoutés à votre portefeuille')),
    );
  }

  Future<void> _validatePurchases() async {
    if (_expenseController.text.isEmpty) return;

    double expense = double.tryParse(_expenseController.text) ?? 0;
    if (expense > 0) {
      await _dbHelper.addExpense(expense, 'Courses');
      _expenseController.clear();
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Achats validés avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Portefeuille Virtuel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Solde actuel
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Solde Actuel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_balance.toStringAsFixed(2)}€',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _rechargeWallet,
                      icon: const Icon(Icons.add),
                      label: const Text('Recharger'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Dernières dépenses
            const Text(
              'Dernières Dépenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(transaction.description),
                      subtitle: Text(
                        '${transaction.date.day}/${transaction.date.month}',
                      ),
                      trailing: Text(
                        '${transaction.amount.toStringAsFixed(2)}€',
                        style: TextStyle(
                          color: transaction.type == 'depense'
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Finaliser les courses
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Finaliser les Courses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _expenseController,
                      decoration: const InputDecoration(
                        labelText: 'Montant Réel Dépensé: €',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _validatePurchases,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Valider les Achats'),
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