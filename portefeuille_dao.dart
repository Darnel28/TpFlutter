import 'database_helper.dart';

class Portefeuille {
  int? id;
  String nom;
  double solde;

  Portefeuille({this.id, required this.nom, required this.solde});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'solde': solde};
  }

  factory Portefeuille.fromMap(Map<String, dynamic> map) {
    return Portefeuille(
      id: map['id'],
      nom: map['nom'],
      solde: map['solde'],
    );
  }
}

class PortefeuilleDao {
  final dbHelper = DatabaseHelper();

  Future<int> insertPortefeuille(Portefeuille wallet) async {
    final db = await dbHelper.database;
    return await db.insert('portefeuille', wallet.toMap());
  }

  Future<Portefeuille?> getPortefeuille() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('portefeuille', limit: 1);
    if (maps.isNotEmpty) {
      return Portefeuille.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePortefeuille(Portefeuille wallet) async {
    final db = await dbHelper.database;
    return await db.update('portefeuille', wallet.toMap(), where: 'id = ?', whereArgs: [wallet.id]);
  }

  Future<int> deletePortefeuille(int id) async {
    final db = await dbHelper.database;
    return await db.delete('portefeuille', where: 'id = ?', whereArgs: [id]);
  }
}
