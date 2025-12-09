class ShoppingItem {
  final int id;
  final int listId;
  final String name;
  final int quantity;
  final double estimatedPrice;
  final double? realPrice;
  final String category;
  final String priority; // 'Faible', 'Moyenne', 'Haute', 'Urgent'
  final bool isPurchased;

  ShoppingItem({
    required this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    required this.estimatedPrice,
    this.realPrice,
    required this.category,
    required this.priority,
    required this.isPurchased,
  });

  double get totalEstimated => estimatedPrice * quantity;
  double get totalReal => (realPrice ?? 0.0) * quantity;
}
