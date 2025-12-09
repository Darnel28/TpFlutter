import 'package:flutter/material.dart';
import '../models/article.dart';

class AddArticlePage extends StatefulWidget {
  final Article? article; // null = nouveau, sinon modification

  const AddArticlePage({super.key, this.article});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _quantiteController;
  late TextEditingController _uniteController;
  late TextEditingController _prixController;
  late TextEditingController _magasinController;

  String _categorieSelectionnee = 'Produits Laitiers';
  String _prioriteSelectionnee = 'Moyen';

  final List<String> _categories = [
    'Produits Laitiers',
    'Fruits et Légumes',
    'Viandes et Poissons',
    'Épicerie',
    'Boissons',
    'Hygiène',
    'Autre',
  ];

  final List<String> _priorites = ['Faible', 'Moyen', 'Urgent'];

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.article?.nom ?? '');
    _quantiteController = TextEditingController(
      text: widget.article?.quantite.toString() ?? '',
    );
    _uniteController = TextEditingController(text: widget.article?.unite ?? '');
    _prixController = TextEditingController(
      text: widget.article?.prixEstime.toString() ?? '',
    );
    _magasinController = TextEditingController(
      text: widget.article?.magasin ?? '',
    );
    
    if (widget.article != null) {
      _categorieSelectionnee = widget.article!.categorie;
      _prioriteSelectionnee = widget.article!.priorite;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _quantiteController.dispose();
    _uniteController.dispose();
    _prixController.dispose();
    _magasinController.dispose();
    super.dispose();
  }

  int _getPrioriteStars() {
    switch (_prioriteSelectionnee) {
      case 'Faible':
        return 1;
      case 'Moyen':
        return 3;
      case 'Urgent':
        return 5;
      default:
        return 3;
    }
  }

  void _setPrioriteFromStars(int stars) {
    setState(() {
      if (stars <= 2) {
        _prioriteSelectionnee = 'Faible';
      } else if (stars <= 4) {
        _prioriteSelectionnee = 'Moyen';
      } else {
        _prioriteSelectionnee = 'Urgent';
      }
    });
  }

  void _enregistrer() {
    if (_formKey.currentState!.validate()) {
      final article = Article(
        id: widget.article?.id,
        nom: _nomController.text,
        quantite: double.parse(_quantiteController.text),
        unite: _uniteController.text,
        prixEstime: double.parse(_prixController.text),
        categorie: _categorieSelectionnee,
        magasin: _magasinController.text,
        priorite: _prioriteSelectionnee,
        aAcheter: widget.article?.aAcheter ?? true,
      );

      Navigator.pop(context, article);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.article == null ? 'Ajouter un Article' : 'Modifier l\'Article',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nom:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _nomController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Requis' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quantité
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quantité:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _quantiteController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Requis';
                              if (double.tryParse(value!) == null) {
                                return 'Nombre invalide';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Prix Estimé
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prix Estimé:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _prixController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        suffixText: 'FCFA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Requis';
                        if (double.tryParse(value!) == null) {
                          return 'Prix invalide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Catégorie
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catégorie:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _categorieSelectionnee,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _categorieSelectionnee = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Magasin
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Magasin:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _magasinController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Requis' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Priorité avec étoiles
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Priorité',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: List.generate(5, (index) {
                            final stars = _getPrioriteStars();
                            return GestureDetector(
                              onTap: () => _setPrioriteFromStars(index + 1),
                              child: Icon(
                                Icons.star,
                                color: index < stars
                                    ? Colors.amber
                                    : Colors.grey[300],
                                size: 32,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _prioriteSelectionnee == 'Urgent'
                                ? Colors.red
                                : _prioriteSelectionnee == 'Moyen'
                                    ? Colors.orange
                                    : Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _prioriteSelectionnee.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // À Acheter checkbox
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'À Acheter',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Boutons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _enregistrer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Enregistrer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
