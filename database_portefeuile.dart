class Portefeuille {
  int? id;
  double solde;

  Portefeuille({this.id, required this.solde});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'solde': solde,
    };
  }

  factory Portefeuille.fromMap(Map<String, dynamic> map) {
    return Portefeuille(
      id: map['id'],
      solde: map['solde'],
    );
  }
}
