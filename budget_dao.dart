import 'database_helper.dart';

class Budget {
  int? id;
  double montant;
  String description;

  Budget({this.id, required this.montant, required this.description});

  Map<String, dynamic> toMap() {
    return {'id': id, 'montant': montant, 'description': description};
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      montant: map['montant'],
      description: map['description'],
    );
  }
}

class BudgetDao {
  final dbHelper = DatabaseHelper();

  Future<int> insertBudget(Budget budget) async {
    final db = await dbHelper.database;
    return await db.insert('budget', budget.toMap());
  }

  Future<Budget?> getBudget() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('budget', limit: 1);
    if (maps.isNotEmpty) {
      return Budget.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBudget(Budget budget) async {
    final db = await dbHelper.database;
    return await db.update('budget', budget.toMap(), where: 'id = ?', whereArgs: [budget.id]);
  }

  Future<int> deleteBudget(int id) async {
    final db = await dbHelper.database;
    return await db.delete('budget', where: 'id = ?', whereArgs: [id]);
  }
}
