import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fg_by_zodyy/pages/introduction/langues_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final slider.CarouselSliderController _carouselController = slider.CarouselSliderController();
  final User? user = FirebaseAuth.instance.currentUser;
  String? _userName;
  String? _userImageUrl;

  int _currentSlide = 0;

  final List<String> _quotes = [
    '"Votre temps est limité, ne le gâchez pas en vivant la vie de quelqu\'un d\'autre." - Steve Jobs',
    '"Le succès n\'est pas final, l\'échec n\'est pas fatal : c\'est le courage de continuer qui compte." - Winston Churchill',
    '"Commencez où vous êtes. Utilisez ce que vous avez. Faites ce que vous pouvez." - Arthur Ashe',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _checkUserLogin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _openModal(); // Ouvrir le modal après que le contexte soit disponible
  }

  Future<void> _loadUserProfile() async {
    if (user != null) {
      setState(() {
        _userName = user?.displayName;
        _userImageUrl = user?.photoURL;
      });
    }
  }

  Future<void> _checkUserLogin() async {
    final box = await Hive.openBox('settings');
    final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectLanguagePage()),
      );
    }
  }

  Future<void> _refreshPage() async {
    await _loadUserProfile();
    setState(() {});
  }

Future<void> _openModal() async {
  // Différer l'appel de setState() après la construction du widget
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permet de contrôler la hauteur
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          height: 700, // Définir la hauteur du modal ici
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.welcome,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text(AppLocalizations.of(context)!.create_account),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(AppLocalizations.of(context)!.sign_in),
              ),
            ],
          ),
        );
      },
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Focus Goals by ZODYY ✨',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 228, 191, 6)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundImage: _userImageUrl != null
                    ? NetworkImage(_userImageUrl!)
                    : const AssetImage('assets/images/rounded_logo.png') as ImageProvider,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 1, 6, 61),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: _userImageUrl != null
                        ? NetworkImage(_userImageUrl!)
                        : const AssetImage('assets/images/user_avatar.png') as ImageProvider,
                    radius: 30,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userName ?? 'User Name',
                    style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(_userName ?? 'User Name', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(AppLocalizations.of(context)!.reset_password, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app), // Icône de déconnexion
              title: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () async {
                await FirebaseAuth.instance.signOut(); // Déconnexion de l'utilisateur
                // Redirection vers la page de login après déconnexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()), // Remplacer LoginPage par ta page de connexion
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: ListView(
          children: [
            slider.CarouselSlider(
              carouselController: _carouselController,
              options: slider.CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 9),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentSlide = index;
                  });
                },
              ),
              items: _quotes.map((quote) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 3, 3, 107),
                            Color.fromARGB(255, 62, 24, 10),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          quote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _carouselController.previousPage(),
                  icon: const Icon(Icons.arrow_circle_left_sharp, color: Color.fromARGB(255, 3, 3, 107)),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: () => _carouselController.nextPage(),
                  icon: const Icon(Icons.arrow_circle_right_sharp, color: Color.fromARGB(255, 62, 24, 10)),
                  iconSize: 40,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.welcome_back,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openModal,
        child: const Icon(Icons.menu),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
