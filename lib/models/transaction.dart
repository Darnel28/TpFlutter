class Transaction {
  int? id;
  double montant;
  String description;
  DateTime date;

  Transaction({
    this.id,
    required this.montant,
    required this.description,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'montant': montant,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      montant: map['montant'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}
