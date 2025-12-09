class ShoppingItem {
  int? id;
  String name;
  String unit;
  double quantity;
  double estimatedPrice;
  String category;
  String store;
  bool toBuy;
  bool urgent;
  bool bulk;
  DateTime createdAt;

  ShoppingItem({
    this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.estimatedPrice,
    required this.category,
    required this.store,
    this.toBuy = true,
    this.urgent = false,
    this.bulk = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'estimatedPrice': estimatedPrice,
      'category': category,
      'store': store,
      'toBuy': toBuy ? 1 : 0,
      'urgent': urgent ? 1 : 0,
      'bulk': bulk ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      quantity: map['quantity'],
      estimatedPrice: map['estimatedPrice'],
      category: map['category'],
      store: map['store'],
      toBuy: map['toBuy'] == 1,
      urgent: map['urgent'] == 1,
      bulk: map['bulk'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  double get totalPrice => quantity * estimatedPrice;
}