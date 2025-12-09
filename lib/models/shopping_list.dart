class ShoppingList {
  final int id;
  final int userId;
  final String name;
  final double budgetMax;
  final double currentTotal; // could be sum of real prices
  final String status; // 'planned', 'inProgress', 'completed'

  ShoppingList({
    required this.id,
    required this.userId,
    required this.name,
    required this.budgetMax,
    required this.currentTotal,
    required this.status,
  });
}
