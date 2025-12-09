class WalletTransaction {
  final int id;
  final int userId;
  final double amount;
  final String type; // 'credit' or 'debit'
  final String description;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });
}
