import 'database_helper.dart';

class Article {
  int? id;
  String nom;
  int quantite;
  double prix;
  String categorie;
  String magasin;
  String statut; // "A acheter", "En cours", "Terminé"
  String priorite; // "Faible", "Moyenne", "Haute", "Urgent"

  Article({
    this.id,
    required this.nom,
    required this.quantite,
    required this.prix,
    this.categorie = '',
    this.magasin = '',
    this.statut = 'A acheter',
    this.priorite = 'Faible',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'quantite': quantite,
      'prix': prix,
      'categorie': categorie,
      'magasin': magasin,
      'statut': statut,
      'priorite': priorite,
    };
  }
}

class ArticleDao {
  final dbHelper = DatabaseHelper();

  Future<int> insertArticle(Article article) async {
    final db = await dbHelper.database;
    return await db.insert('articles', article.toMap());
  }

  Future<List<Article>> getArticles() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('articles');
    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
        quantite: maps[i]['quantite'],
        prix: maps[i]['prix'],
        categorie: maps[i]['categorie'],
        magasin: maps[i]['magasin'],
        statut: maps[i]['statut'],
        priorite: maps[i]['priorite'],
      );
    });
  }

  Future<int> updateArticle(Article article) async {
    final db = await dbHelper.database;
    return await db.update(
      'articles',
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  Future<int> deleteArticle(int id) async {
    final db = await dbHelper.database;
    return await db.delete('articles', where: 'id = ?', whereArgs: [id]);
  }
}
