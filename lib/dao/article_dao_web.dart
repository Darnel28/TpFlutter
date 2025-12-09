import 'dart:html' as html;
import 'dart:convert';
import '../models/article.dart';

class ArticleDaoWeb {
  static const String _storageKey = 'course_manager_articles';

  Future<List<Article>> getAllArticles() async {
    try {
      final stored = html.window.localStorage[_storageKey];
      if (stored == null) return [];
      
      final List<dynamic> jsonList = jsonDecode(stored);
      return jsonList.map((item) => Article.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erreur lors de la lecture des articles: $e');
      return [];
    }
  }

  Future<void> insertArticle(Article article) async {
    try {
      final articles = await getAllArticles();
      article.id = articles.isEmpty ? 1 : (articles.map((a) => a.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      articles.add(article);
      await _saveArticles(articles);
      print('✅ Article ajouté: ${article.nom}');
    } catch (e) {
      print('Erreur lors de l\'ajout: $e');
    }
  }

  Future<void> updateArticle(Article article) async {
    try {
      final articles = await getAllArticles();
      final index = articles.indexWhere((a) => a.id == article.id);
      if (index != -1) {
        articles[index] = article;
        await _saveArticles(articles);
        print('✅ Article modifié: ${article.nom}');
      }
    } catch (e) {
      print('Erreur lors de la modification: $e');
    }
  }

  Future<void> deleteArticle(int id) async {
    try {
      var articles = await getAllArticles();
      articles.removeWhere((a) => a.id == id);
      await _saveArticles(articles);
      print('✅ Article supprimé');
    } catch (e) {
      print('Erreur lors de la suppression: $e');
    }
  }

  Future<void> _saveArticles(List<Article> articles) async {
    final jsonList = articles.map((a) => a.toMap()).toList();
    html.window.localStorage[_storageKey] = jsonEncode(jsonList);
  }

  double getTotalDepenseEstimee(List<Article> articles) {
    return articles.fold(0.0, (sum, a) => sum + a.prixEstime);
  }

  double getBudgetMax(double depenseEstimee) {
    return depenseEstimee * 1.05; // +5%
  }

  List<Article> sortByPriorite(List<Article> articles) {
    final prioriteOrder = {'Urgent': 0, 'Moyen': 1, 'Faible': 2};
    articles.sort((a, b) => (prioriteOrder[a.priorite] ?? 99).compareTo(prioriteOrder[b.priorite] ?? 99));
    return articles;
  }
}
