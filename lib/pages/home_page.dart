

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fg_by_zodyy/pages/introduction/langues_page.dart'; // Assurez-vous que cette page existe

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final slider.CarouselSliderController _carouselController = slider.CarouselSliderController();
  int _currentSlide = 0;

  final List<String> _quotes = [
    '"Votre temps est limité, ne le gâchez pas en vivant la vie de quelqu\'un d\'autre." - Steve Jobs',
    '"Le succès n\'est pas final, l\'échec n\'est pas fatal : c\'est le courage de continuer qui compte." - Winston Churchill',
    '"Commencez où vous êtes. Utilisez ce que vous avez. Faites ce que vous pouvez." - Arthur Ashe',
  ];

  @override
  void initState() {
    super.initState();
    _checkUserLogin();
  }

  // Vérifie si l'utilisateur est connecté
  Future<void> _checkUserLogin() async {
    final box = await Hive.openBox('settings');
    final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

    if (!isLoggedIn) {
      // Si l'utilisateur n'est pas connecté, redirigez vers la page de choix de langue
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectLanguagePage()),
      );
    }
  }

  void _openModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Goals by ZODYY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user_avatar.png'),
                    radius: 30,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(AppLocalizations.of(context)!.name),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(AppLocalizations.of(context)!.reset_password),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.welcome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          slider.CarouselSlider(
            carouselController: _carouselController,
            options: slider.CarouselOptions(
              height: 200,
              autoPlay: true,
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
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: Center(
                      child: Text(
                        quote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
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
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                onPressed: () => _carouselController.nextPage(),
                icon: const Icon(Icons.arrow_forward),
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
