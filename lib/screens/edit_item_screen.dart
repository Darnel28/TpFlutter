import 'package:flutter/material.dart';
import 'package:projetgroupe/database/database_helper.dart';
import 'package:projetgroupe/models/item.dart';

class EditItemScreen extends StatefulWidget {
  final ShoppingItem? item;

  const EditItemScreen({super.key, this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _storeController = TextEditingController();

  String _selectedCategory = 'Produits Laitiers';
  bool _toBuy = true;
  bool _urgent = false;
  bool _bulk = false;

  final List<String> _categories = [
    'Produits Laitiers',
    'Fruits & Légumes',
    'Viandes & Poissons',
    'Épicerie',
    'Boissons',
    'Hygiène',
    'Maison',
    'Autre'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _unitController.text = widget.item!.unit;
      _quantityController.text = widget.item!.quantity.toString();
      _priceController.text = widget.item!.estimatedPrice.toString();
      _storeController.text = widget.item!.store;
      _selectedCategory = widget.item!.category;
      _toBuy = widget.item!.toBuy;
      _urgent = widget.item!.urgent;
      _bulk = widget.item!.bulk;
    } else {
      _unitController.text = 'L';
      _storeController.text = 'Super U (Faciatqul)';
    }
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final item = ShoppingItem(
        id: widget.item?.id,
        name: _nameController.text,
        unit: _unitController.text,
        quantity: double.parse(_quantityController.text),
        estimatedPrice: double.parse(_priceController.text),
        category: _selectedCategory,
        store: _storeController.text,
        toBuy: _toBuy,
        urgent: _urgent,
        bulk: _bulk,
      );

      if (widget.item == null) {
        await _dbHelper.insertItem(item);
      } else {
        await _dbHelper.updateItem(item);
      }

      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteItem() async {
    if (widget.item != null) {
      await _dbHelper.deleteItem(widget.item!.id!);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Ajouter Article' : 'Modifier Article'),
        actions: [
          if (widget.item != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteItem,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nom
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Unité
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: 'Unité',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une unité';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantité
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                  border: OutlineInputBorder(),
                  suffixText: 'ex: 2',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une quantité';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Prix Estimé
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Prix Estimé (€)',
                  border: OutlineInputBorder(),
                  prefixText: '€',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Catégorie
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Magasin
              TextFormField(
                controller: _storeController,
                decoration: const InputDecoration(
                  labelText: 'Magasin',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Checkboxes
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Propriétés',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        title: const Text('À Acheter'),
                        value: _toBuy,
                        onChanged: (value) {
                          setState(() {
                            _toBuy = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Urgent'),
                        value: _urgent,
                        onChanged: (value) {
                          setState(() {
                            _urgent = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('En gros'),
                        value: _bulk,
                        onChanged: (value) {
                          setState(() {
                            _bulk = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Boutons
              ElevatedButton(
                onPressed: _saveItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(widget.item == null ? 'Ajouter' : 'Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}