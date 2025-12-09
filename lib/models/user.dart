class User {
  int? id;
  String nom;
  String email;
  String motDePasse;

  User({
    this.id,
    required this.nom,
    required this.email,
    required this.motDePasse,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'motDePasse': motDePasse,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nom: map['nom'],
      email: map['email'],
      motDePasse: map['motDePasse'],
    );
  }
}
