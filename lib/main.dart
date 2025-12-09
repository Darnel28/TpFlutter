import 'package:flutter/material.dart';
import 'package:projetgroupe/database/database_helper.dart';
import 'package:projetgroupe/models/item.dart';
import 'package:projetgroupe/models/transaction.dart' as my_models;
import 'package:projetgroupe/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser la base de données et ajouter des données d'exemple
  await _initializeApp();
  
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  final dbHelper = DatabaseHelper();
  
  // Vérifier si des données existent déjà
  final items = await dbHelper.getItems();
  
  if (items.isEmpty) {
    // CORRECTION : Utilisez des objets ShoppingItem, pas des Maps
    await dbHelper.insertItem(ShoppingItem(
      name: 'Lait',
      unit: 'L',
      quantity: 2.0,
      estimatedPrice: 1.90,
      category: 'Produits Laitiers',
      store: 'Super U (Faciatqul)',
      toBuy: true,    // true au lieu de 1
      urgent: false,  // false au lieu de 0
      bulk: false,    // false au lieu de 0
      // createdAt est automatiquement défini par défaut
    ));
    
    await dbHelper.insertItem(ShoppingItem(
      name: 'Pommes',
      unit: 'kg',
      quantity: 1.0,
      estimatedPrice: 2.50,
      category: 'Fruits & Légumes',
      store: 'Super U (Faciatqul)',
      toBuy: true,   // true au lieu de 1
      urgent: true,  // true au lieu de 1
      bulk: false,   // false au lieu de 0
    ));
    
    await dbHelper.insertItem(ShoppingItem(
      name: 'Pâtes',
      unit: 'paquet',
      quantity: 3.0,
      estimatedPrice: 1.90,
      category: 'Épicerie',
      store: 'Super U (Faciatqul)',
      toBuy: true,    // true au lieu de 1
      urgent: false,  // false au lieu de 0
      bulk: true,     // true au lieu de 1
    ));
    
    // CORRECTION : Utilisez des objets ExpenseTransaction, pas des Maps
    await dbHelper.insertTransaction(my_models.Transaction(
      amount: 178.50,
      description: 'Courses du 08/12',
      date: DateTime(2024, 12, 8),  // Objet DateTime, pas String
      type: 'depense',
    ));
    
    await dbHelper.insertTransaction(my_models.Transaction(
      amount: 210.25,
      description: 'Courses',
      date: DateTime(2024, 12, 1),  // Objet DateTime, pas String
      type: 'depense',
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Portefeuille Virtuel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}