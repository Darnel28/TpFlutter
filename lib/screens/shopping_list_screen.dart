import 'package:flutter/material.dart';
import 'package:projetgroupe/database/database_helper.dart';
import 'package:projetgroupe/models/item.dart';
import 'package:projetgroupe/screens/edit_item_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<ShoppingItem> _items = [];
  double _budgetMax = 200.0;
  double _estimatedExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    _items = await _dbHelper.getItems();
    _calculateTotals();
    setState(() {});
  }

  void _calculateTotals() {
    _estimatedExpense = _items.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  double get _remainingBalance => _budgetMax - _estimatedExpense;

  Future<void> _addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemScreen(item: null),
      ),
    );

    if (result == true) {
      await _loadItems();
    }
  }

  Future<void> _editItem(ShoppingItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemScreen(item: item),
      ),
    );

    if (result == true) {
      await _loadItems();
    }
  }

  Future<void> _deleteItem(int id) async {
    await _dbHelper.deleteItem(id);
    await _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Liste Actuelle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec budget
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Budget Max:'),
                        Text(
                          '${_budgetMax.toStringAsFixed(2)}€',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dépense Estimée:'),
                        Text(
                          '${_estimatedExpense.toStringAsFixed(2)}€',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Solde Restant:'),
                        Text(
                          '${_remainingBalance.toStringAsFixed(2)}€',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _remainingBalance >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Liste des articles
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: item.urgent
                          ? const Icon(Icons.warning, color: Colors.red)
                          : null,
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantité: x${item.quantity} ${item.unit}'),
                          Text(
                            'Prix Estimé: ${item.totalPrice.toStringAsFixed(2)}€',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (item.category.isNotEmpty)
                            Chip(
                              label: Text(item.category),
                              backgroundColor: Colors.blue[50],
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editItem(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(item.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}