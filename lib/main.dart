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

class _TaskItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _TaskItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double percent;
  final Color color;

  const _ProjectCard({
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 5,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Center(
                  child: Text(
                    '${(percent * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
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
  final UserDaoWeb _userDao = UserDaoWeb();

  int _totalTasks = 0;
  int _pendingTasks = 0;
  int _doneTasks = 0;
  String _userName = 'Utilisateur';
  String _userRole = 'Course Manager';

  @override
  void initState() {
    super.initState();
    _refreshTasks();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await _userDao.getLoggedUser();
    if (user != null) {
      setState(() {
        _userName = user.nom;
        _userRole = 'Course Manager';
      });
    }
  }

  Future<void> _refreshTasks() async {
    final articles = await _articleDao.getAllArticles();
    final pending = articles.where((a) => a.aAcheter).length;
    setState(() {
      _totalTasks = articles.length;
      _pendingTasks = pending;
      _doneTasks = articles.length - pending;
    });
  }

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
            _refreshTasks();
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
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
    const bg = Color(0xFFF6F0E7);
    return Container(
      color: bg,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec avatar, menu et recherche
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF65B2FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
                          onSelected: (value) async {
                            if (value == 'connect') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            } else if (value == 'disconnect') {
                              await _userDao.logout();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Déconnecté'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'connect',
                              child: Text('Se connecter'),
                            ),
                            PopupMenuItem(
                              value: 'disconnect',
                              child: Text('Se déconnecter'),
                            ),
                          ],
                        ),
                        const Icon(Icons.search, color: Colors.black87, size: 26),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, size: 42, color: Colors.black87),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userRole,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section My Tasks
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Mes tâches',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF0F9B8E),
                    child: Icon(Icons.calendar_today, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _TaskItem(
                    title: 'À faire',
                    subtitle: '$_pendingTasks tâches à faire.',
                    color: const Color(0xFFE96A6A),
                    icon: Icons.access_time,
                  ),
                  const SizedBox(height: 14),
                  _TaskItem(
                    title: 'En cours',
                    subtitle: '$_pendingTasks tâches en cours.',
                    color: const Color(0xFFF5C16C),
                    icon: Icons.timelapse,
                  ),
                  const SizedBox(height: 14),
                  _TaskItem(
                    title: 'Terminées',
                    subtitle: '$_doneTasks tâches terminées.',
                    color: const Color(0xFF5D77FF),
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Accès Rapide
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Accès Rapide',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildElegantCard(
                    title: 'Liste Actuelle',
                    icon: Icons.shopping_bag_outlined,
                    color: Colors.blue,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                  _buildElegantCard(
                    title: 'Portefeuille',
                    icon: Icons.account_balance_wallet_outlined,
                    color: Colors.purple,
                    onTap: () => setState(() => _currentIndex = 3),
                  ),
                  _buildElegantCard(
                    title: 'Statistiques',
                    icon: Icons.trending_up_outlined,
                    color: Colors.orange,
                    onTap: () => setState(() => _currentIndex = 4),
                  ),
                  _buildElegantCard(
                    title: 'Ajouter Article',
                    icon: Icons.add_circle_outline,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddArticlePage(),
                        ),
                      ).then((article) {
                        if (article != null) {
                          _articleDao.insertArticle(article);
                          _refreshTasks();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildElegantCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
