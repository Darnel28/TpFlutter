import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';
import '../models/transaction.dart' as my_models;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mon_portefeuille.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table pour les articles de courses
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        unit TEXT NOT NULL,
        quantity REAL NOT NULL,
        estimatedPrice REAL NOT NULL,
        category TEXT NOT NULL,
        store TEXT NOT NULL,
        toBuy INTEGER NOT NULL,
        urgent INTEGER NOT NULL,
        bulk INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Table pour les transactions
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    // Table pour le solde
    await db.execute('''
      CREATE TABLE balance(
        id INTEGER PRIMARY KEY,
        amount REAL NOT NULL
      )
    ''');

    // Insérer le solde initial
    await db.insert('balance', {'id': 1, 'amount': 452.0});
  }

  // CRUD pour les articles
  Future<int> insertItem(ShoppingItem item) async {
    Database db = await database;
    return await db.insert('items', item.toMap());
  }

  Future<List<ShoppingItem>> getItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) => ShoppingItem.fromMap(maps[i]));
  }

  Future<int> updateItem(ShoppingItem item) async {
    Database db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD pour les transactions - CORRIGEZ LE TYPE DE RETOUR ICI
  Future<int> insertTransaction(my_models.Transaction transaction) async {
    Database db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<my_models.Transaction>> getTransactions() async { // Type de retour corrigé
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
      limit: 3,
    );
    // Utilisez my_models.ExpenseTransaction.fromMap
    return List.generate(maps.length, (i) => my_models.Transaction.fromMap(maps[i]));
  }

  // Gestion du solde
  Future<double> getBalance() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('balance');
    if (maps.isNotEmpty) {
      return maps.first['amount'];
    }
    return 0.0;
  }

  Future<void> updateBalance(double amount) async {
    Database db = await database;
    await db.update(
      'balance',
      {'amount': amount},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> rechargeBalance(double amount) async {
    double currentBalance = await getBalance();
    await updateBalance(currentBalance + amount);
    
    // Enregistrer la transaction de recharge
    await insertTransaction(my_models.Transaction(
      amount: amount,
      description: 'Rechargement',
      date: DateTime.now(),
      type: 'recharge',
    ));
  }

  Future<void> addExpense(double amount, String description) async {
    double currentBalance = await getBalance();
    await updateBalance(currentBalance - amount);
    
    // Enregistrer la transaction de dépense
    await insertTransaction(my_models.Transaction(
      amount: amount,
      description: description,
      date: DateTime.now(),
      type: 'depense',
    ));
  }
}