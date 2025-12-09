import 'dart:html' as html;
import 'dart:convert';
import '../models/transaction.dart';

class TransactionDaoWeb {
  static const String _storageKey = 'course_manager_transactions';

  Future<List<Transaction>> getAllTransactions() async {
    try {
      final stored = html.window.localStorage[_storageKey];
      if (stored == null) return [];
      
      final List<dynamic> jsonList = jsonDecode(stored);
      return jsonList.map((item) => Transaction.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erreur lors de la lecture des transactions: $e');
      return [];
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final transactions = await getAllTransactions();
      transaction.id = transactions.isEmpty ? 1 : (transactions.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      transactions.add(transaction);
      await _saveTransactions(transactions);
      print('✅ Transaction ajoutée: ${transaction.description}');
    } catch (e) {
      print('Erreur lors de l\'ajout: $e');
    }
  }

  Future<List<Transaction>> getLastTransactions(int limit) async {
    final transactions = await getAllTransactions();
    final sorted = List<Transaction>.from(transactions)..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  Future<void> _saveTransactions(List<Transaction> transactions) async {
    final jsonList = transactions.map((t) => t.toMap()).toList();
    html.window.localStorage[_storageKey] = jsonEncode(jsonList);
  }
}
