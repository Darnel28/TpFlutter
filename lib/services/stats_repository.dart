import '../models/shopping_item.dart';
import '../models/shopping_list.dart';
import '../models/wallet_transaction.dart';

class StatsRepository {
  // Mock data for now (replace with API calls later)
  final ShoppingList list = ShoppingList(
    id: 1,
    userId: 1,
    name: 'Courses de la semaine',
    budgetMax: 150.00,
    currentTotal: 0.0, // will be computed from items real prices if present
    status: 'inProgress',
  );

  final List<ShoppingItem> items = [
    ShoppingItem(
      id: 1, listId: 1, name: 'Pommes', quantity: 2,
      estimatedPrice: 3.50, realPrice: null,
      category: 'Fruits & Légumes', priority: 'Haute', isPurchased: false,
    ),
    ShoppingItem(
      id: 2, listId: 1, name: 'Lait', quantity: 1,
      estimatedPrice: 1.20, realPrice: null,
      category: 'Produits Laitiers', priority: 'Moyenne', isPurchased: false,
    ),
    ShoppingItem(
      id: 3, listId: 1, name: 'Pain', quantity: 1,
      estimatedPrice: 1.50, realPrice: null,
      category: 'Alimentaire', priority: 'Faible', isPurchased: false,
    ),
  ];

  final List<WalletTransaction> transactions = [
    WalletTransaction(
      id: 1, userId: 1, amount: 500.00, type: 'credit',
      description: 'Dépôt initial', createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    WalletTransaction(
      id: 2, userId: 1, amount: 25.00, type: 'debit',
      description: 'Courses part 1', createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // KPI 1: Budget vs Dépenses
  double get budgetMax => list.budgetMax;
  double get totalEstimated => items.fold(0.0, (sum, i) => sum + i.totalEstimated);
  double get totalReal => items.fold(0.0, (sum, i) => sum + i.totalReal);
  double get spend => totalReal > 0 ? totalReal : totalEstimated; // fallback to estimated if no real

  // KPI 2: Répartition par catégorie
  Map<String, double> get totalByCategory {
    final Map<String, double> map = {};
    for (final i in items) {
      map[i.category] = (map[i.category] ?? 0) + i.totalEstimated;
    }
    return map;
  }

  // KPI 3: Priorités
  Map<String, int> get countByPriority {
    final Map<String, int> map = {'Faible': 0, 'Moyenne': 0, 'Haute': 0, 'Urgent': 0};
    for (final i in items) {
      map[i.priority] = (map[i.priority] ?? 0) + 1;
    }
    return map;
  }

  // KPI 4: Progression des achats
  double get purchaseProgress {
    final total = items.length;
    final bought = items.where((i) => i.isPurchased).length;
    if (total == 0) return 0;
    return (bought / total) * 100.0;
  }

  // KPI 5: Portefeuille
  double get walletCredits => transactions.where((t) => t.type == 'credit').fold(0.0, (s, t) => s + t.amount);
  double get walletDebits  => transactions.where((t) => t.type == 'debit').fold(0.0, (s, t) => s + t.amount);
  double get walletBalance => walletCredits - walletDebits;
}
