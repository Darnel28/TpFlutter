import 'package:flutter/material.dart';
import '../models/article.dart';
import '../dao/article_dao_web.dart';
import '../dao/transaction_dao_web.dart';
import '../models/transaction.dart';
import 'dart:html' as html;

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final ArticleDaoWeb _articleDao = ArticleDaoWeb();
  late List<Article> articles = [];
  double soldePortefeuille = 452.00;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final articlesChargees = await _articleDao.getAllArticles();
    final soldeStored = html.window.localStorage['wallet_solde'];
    
    setState(() {
      articles = _articleDao.sortByPriorite(
        articlesChargees.where((a) => a.aAcheter).toList(),
      );
      soldePortefeuille = soldeStored != null ? double.parse(soldeStored) : 452.00;
    });
  }

  Color _getCouleurPriorite(String priorite) {
    switch (priorite) {
      case 'Urgent':
        return Colors.red;
      case 'Moyen':
        return Colors.amber;
      case 'Faible':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  double _getTotalDepense() => _articleDao.getTotalDepenseEstimee(articles);

  double _getBudgetMax() => _articleDao.getBudgetMax(_getTotalDepense());

  double _getSoldeRestant() => soldePortefeuille - _getBudgetMax();

  void _marquerAchete(Article article) async {
    article.aAcheter = false;
    await _articleDao.updateArticle(article);
    // Créer une transaction pour cet achat
    final transactionDao = TransactionDaoWeb();
    final transaction = Transaction(
      montant: article.prixEstime,
      description: article.nom,
    );
    await transactionDao.addTransaction(transaction);
    await _chargerDonnees();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Article marqué comme acheté'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalDepense = _getTotalDepense();
    final budgetMax = _getBudgetMax();
    final soldeRestant = _getSoldeRestant();
    final progressionBudget = (totalDepense / budgetMax).clamp(0.0, 1.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            const Text(
              'Ma Liste Actuelle',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Card Info Budget
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue[50],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget Max: ${budgetMax.toStringAsFixed(2)} FCFA',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Dépense Estimée: ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '${totalDepense.toStringAsFixed(2)} FCFA',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Solde Restant: ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '${soldeRestant.toStringAsFixed(2)} FCFA',
                          style: TextStyle(
                            color: soldeRestant < 0 ? Colors.red : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Barre de progression
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressionBudget,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressionBudget > 0.9
                            ? Colors.red
                            : progressionBudget > 0.7
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Liste des articles
            if (articles.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun article à acheter',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: articles.map((article) {
                  return _buildArticleCard(article);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
    final couleur = _getCouleurPriorite(article.priorite);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Couleur et priorité
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: couleur,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  article.priorite.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Informations article
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.nom,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantité: ${article.quantite}${article.unite}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Prix Estimé: ${article.prixEstime.toStringAsFixed(2)} FCFA',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Badge priorité + Toggle
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: couleur,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    article.priorite.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _marquerAchete(article),
                  child: Container(
                    width: 50,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
