import '../database_helper.dart';
import '../models/user.dart';

class UserDao {
  final dbHelper = DatabaseHelper();

  // Insérer un nouvel utilisateur
  Future<int> insertUser(User user) async {
    final db = await dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  // Vérifier si un utilisateur existe avec email et mot de passe
  Future<User?> getUserByEmailAndPassword(String email, String motDePasse) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND motDePasse = ?',
      whereArgs: [email, motDePasse],
    );
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Vérifier si un email existe déjà
  Future<bool> emailExists(String email) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  // Obtenir tous les utilisateurs
  Future<List<User>> getAllUsers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }
}
