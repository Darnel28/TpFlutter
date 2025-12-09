class Budget {
  int? id;
  double montantMax;
  double depense;

  Budget({this.id, required this.montantMax, this.depense = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'montant_max': montantMax,
      'depense': depense,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      montantMax: map['montant_max'],
      depense: map['depense'],
    );
  }
}
