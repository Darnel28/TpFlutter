import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';
import '../dao/transaction_dao_web.dart';
import '../models/transaction.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double soldeActuel = 452.00;
  final TextEditingController _montantRealController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  static const String _storageKey = 'wallet_solde';
  late TransactionDaoWeb _transactionDao;
  List<Transaction> derniereDepenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _transactionDao = TransactionDaoWeb();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      final stored = html.window.localStorage[_storageKey];
      double soldeTemp = 452.00;
      if (stored != null) {
        try {
          soldeTemp = double.parse(stored);
        } catch (e) {
          soldeTemp = 452.00;
        }
      }
      final transactions = await _transactionDao.getLastTransactions(2);
      if (mounted) {
        setState(() {
          soldeActuel = soldeTemp;
          derniereDepenses = transactions;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          soldeActuel = 452.00;
          derniereDepenses = [];
          isLoading = false;
        });
      }
    }
  }

  void _sauvegarderSolde() {
    html.window.localStorage[_storageKey] = soldeActuel.toString();
  }

  void _afficherDialogRecharge() {
    _montantController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recharger le solde'),
        content: TextField(
          controller: _montantController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Montant à recharger',
            suffixText: 'FCFA',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final montant = double.tryParse(_montantController.text);
              if (montant != null && montant > 0) {
                setState(() {
                  soldeActuel += montant;
                  _sauvegarderSolde();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Solde rechargé de $montant FCFA'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Veuillez entrer un montant valide'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Recharger'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Titre
            const Text(
              'Mon Portefeuille Virtuel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Card Solde Actuel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solde Actuel',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${soldeActuel.toStringAsFixed(2)} FCFA',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _afficherDialogRecharge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      '+ Recharger',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Dernières Dépenses
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dernières Dépenses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                if (derniereDepenses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Aucune dépense enregistrée',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: derniereDepenses
                        .map(
                          (transaction) => Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '- ${transaction.montant.toStringAsFixed(2)} FCFA',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  transaction.description,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${transaction.date.day}/${transaction.date.month}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Finaliser les Courses
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Finaliser les Courses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Affichage du montant réel dépensé (dernière transaction)
                  if (derniereDepenses.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Montant réel dépensé : ${derniereDepenses.first.montant.toStringAsFixed(2)} FCFA',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  TextField(
                    controller: _montantRealController,
                    decoration: InputDecoration(
                      hintText: 'Montant Réel Dépensé: FCFA',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final montantReel = double.tryParse(_montantRealController.text);
                        if (montantReel != null && montantReel > 0) {
                          // Déduire du solde
                          setState(() {
                            soldeActuel -= montantReel;
                            _sauvegarderSolde();
                          });
                          // Sauvegarder la transaction
                          final transaction = Transaction(
                            montant: montantReel,
                            description: 'Courses',
                          );
                          await _transactionDao.addTransaction(transaction);
                          // Réinitialiser et rafraîchir
                          _montantRealController.clear();
                          await _chargerDonnees();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Achats validés: -$montantReel FCFA'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez entrer un montant valide'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Valider les Achats',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _montantController.dispose();
    _montantRealController.dispose();
    super.dispose();
  }
}
