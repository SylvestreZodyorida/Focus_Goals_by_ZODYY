import 'package:flutter/material.dart';
import 'package:fg_by_zodyy/pages/introduction/langues_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.title});

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  // Navigue vers la page d'accueil après 3 secondes
  void _navigateToHomePage() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SelectLanguagePage(title: 'Next Page'), // Passez un titre ici
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 101, 53, 1),
      body: Center(
        child: Image.asset(
          'assets/images/welcome_screen.png', // Remplacez par le chemin de votre image
          fit: BoxFit.cover, // Recouvre tout l'écran
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
