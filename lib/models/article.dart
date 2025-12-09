class Article {
  int? id;
  String nom;
  double quantite;
  String unite;
  double prixEstime;
  String categorie;
  String magasin;
  String priorite; // 'Faible', 'Moyen', 'Urgent'
  bool aAcheter;

  Article({
    this.id,
    required this.nom,
    required this.quantite,
    required this.unite,
    required this.prixEstime,
    required this.categorie,
    required this.magasin,
    required this.priorite,
    this.aAcheter = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'quantite': quantite,
      'unite': unite,
      'prixEstime': prixEstime,
      'categorie': categorie,
      'magasin': magasin,
      'priorite': priorite,
      'aAcheter': aAcheter ? 1 : 0,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      nom: map['nom'],
      quantite: map['quantite'],
      unite: map['unite'],
      prixEstime: map['prixEstime'],
      categorie: map['categorie'],
      magasin: map['magasin'],
      priorite: map['priorite'],
      aAcheter: map['aAcheter'] == 1,
    );
  }
}
