import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'pages/login_page.dart';
import 'pages/statistics_pages.dart';
import 'pages/wallet_page.dart';
import 'pages/add_article_page.dart';
import 'pages/shopping_list_page.dart';
import 'dao/user_dao_web.dart';
import 'dao/article_dao_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  Widget homePage = const LoginPage();
  
  // Vérifier si l'utilisateur est connecté (web uniquement)
  if (kIsWeb) {
    final userDao = UserDaoWeb();
    final loggedUser = await userDao.getLoggedUser();
    
    if (loggedUser != null) {
      homePage = const MyHomePage();
      print('✅ Utilisateur déjà connecté: ${loggedUser.email}');
    }
  }
  
  runApp(MyApp(homePage: homePage));
}

class MyApp extends StatelessWidget {
  final Widget homePage;
  
  const MyApp({super.key, required this.homePage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: homePage,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final ArticleDaoWeb _articleDao = ArticleDaoWeb();

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(context),
      const ShoppingListPage(),
      const Center(child: Text('Ajouter')),
      const WalletPage(),
      const StatisticsPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavButton(
                  icon: Icons.person_outline,
                  label: 'Accueil',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _buildNavButton(
                  icon: Icons.bookmark_outline,
                  label: 'ListeActuelle',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _buildAddButton(context),
                _buildNavButton(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Portefeuille',
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
                _buildNavButton(
                  icon: Icons.bar_chart_outlined,
                  label: 'Statistiques',
                  isSelected: _currentIndex == 4,
                  onTap: () => setState(() => _currentIndex = 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddArticlePage(),
          ),
        ).then((article) {
          if (article != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Article ajouté avec succès'),
                backgroundColor: Colors.green,
              ),
            );
            _articleDao.insertArticle(article);
            setState(() => _currentIndex = 1);
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu, size: 30),
                onSelected: (value) {
                  // Actions de connexion/déconnexion à implémenter
                },
                itemBuilder: (BuildContext context) => const [
                  PopupMenuItem<String>(
                    value: 'connect',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue),
                        SizedBox(width: 12),
                        Text('Se connecter'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'disconnect',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Se déconnecter'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Text(
          'Course Manager',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildMenuCard('Liste Actuelle', Icons.list_alt, Colors.blue, onTap: () {
                  setState(() => _currentIndex = 1);
                }),
                _buildMenuCard('Budget', Icons.savings, Colors.green, onTap: () {
                  // navigate to budget page (placeholder)
                }),
                _buildMenuCard('Portefeuille', Icons.account_balance_wallet, Colors.purple, onTap: () {
                  setState(() => _currentIndex = 3);
                }),
                _buildMenuCard('Statistics /\nPriorités', Icons.trending_up, Colors.orange, onTap: () {
                  setState(() => _currentIndex = 4);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, {required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
