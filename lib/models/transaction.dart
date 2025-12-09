class Transaction {
  int? id;
  double amount;
  String description;
  DateTime date;
  String type; 

  Transaction({
    this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}