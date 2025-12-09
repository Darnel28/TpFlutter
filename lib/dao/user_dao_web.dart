import 'dart:convert';
import 'dart:html' as html;
import '../models/user.dart';

class UserDaoWeb {
  static const String _usersKey = 'course_manager_users';
  static const String _sessionKey = 'course_manager_session';
  
  static final html.Storage _localStorage = html.window.localStorage;

  // Insérer un nouvel utilisateur
  Future<int> insertUser(User user) async {
    final users = await getAllUsers();
    
    // Générer un ID
    final newId = users.isEmpty ? 1 : (users.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    user.id = newId;
    
    users.add(user);
    await _saveUsers(users);
    
    print('✅ Utilisateur inscrit: ${user.email}');
    print('📊 Total utilisateurs: ${users.length}');
    
    return newId;
  }

  // Vérifier si un utilisateur existe avec email et mot de passe
  Future<User?> getUserByEmailAndPassword(String email, String motDePasse) async {
    final users = await getAllUsers();
    print('🔍 Recherche utilisateur: $email');
    print('📊 Utilisateurs en base: ${users.length}');
    
    try {
      final user = users.firstWhere(
        (user) => user.email == email && user.motDePasse == motDePasse,
      );
      print('✅ Utilisateur trouvé!');
      return user;
    } catch (e) {
      print('❌ Utilisateur non trouvé');
      return null;
    }
  }

  // Vérifier si un email existe déjà
  Future<bool> emailExists(String email) async {
    final users = await getAllUsers();
    return users.any((user) => user.email == email);
  }

  // Obtenir tous les utilisateurs
  Future<List<User>> getAllUsers() async {
    try {
      final String? usersJson = _localStorage[_usersKey];
      
      print('📖 Lecture localStorage: ${usersJson ?? "VIDE"}');
      
      if (usersJson == null || usersJson.isEmpty) {
        return [];
      }
      
      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.map((json) => User.fromMap(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('❌ Erreur lecture: $e');
      return [];
    }
  }

  // Sauvegarder tous les utilisateurs
  Future<void> _saveUsers(List<User> users) async {
    try {
      final usersJson = jsonEncode(users.map((user) => user.toMap()).toList());
      _localStorage[_usersKey] = usersJson;
      print('💾 Sauvegarde localStorage: OK');
      print('📝 Données: $usersJson');
    } catch (e) {
      print('❌ Erreur sauvegarde: $e');
    }
  }

  // 🔐 Sauvegarder la session après login
  Future<void> saveSession(User user) async {
    _localStorage[_sessionKey] = user.id.toString();
    print('🔐 Session sauvegardée pour l\'utilisateur ID ${user.id}');
  }

  // 👤 Récupérer l'utilisateur connecté
  Future<User?> getLoggedUser() async {
    final String? userId = _localStorage[_sessionKey];
    
    if (userId == null) {
      print('📋 Aucune session active');
      return null;
    }

    final users = await getAllUsers();
    try {
      final user = users.firstWhere(
        (user) => user.id.toString() == userId,
      );
      print('🔑 Utilisateur connecté trouvé: ${user.email}');
      return user;
    } catch (e) {
      print('❌ Session invalide');
      return null;
    }
  }

  // 🚪 Se déconnecter
  Future<void> logout() async {
    _localStorage.remove(_sessionKey);
    print('🚪 Déconnecté !');
  }
}



