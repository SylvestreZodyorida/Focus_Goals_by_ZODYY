

import 'package:fg_by_zodyy/pages/home_page.dart';
import 'package:fg_by_zodyy/pages/user/signUp_page.dart';
import 'package:fg_by_zodyy/pages/user/emailSignIn_page.dart';
import 'package:flutter/material.dart';
import 'package:fg_by_zodyy/pages/user/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import de la classe générée par l10n
import 'package:fg_by_zodyy/main.dart'; // Import du gestionnaire de langues
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import de Hive

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String _email = '';
  String _password = '';

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        // Mettre à jour la langue dans Hive après connexion
        var box = await Hive.openBox('settings');
        
        // Sauvegarde de la langue actuelle
        await box.put('language', LanguageManager.getCurrentLanguage());
        
        // Mettre à jour l'état de connexion dans Hive
        await box.put('isLoggedIn', true);

        // Naviguer vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur d\'authentification: $error')),
      );
    }
  }

  void _signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = LanguageManager.getCurrentLanguage();
    Locale currentLocale = Locale(currentLanguage);

    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ajout de cette ligne pour gérer l'affichage du clavier
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fond.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 140),
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    'assets/images/rounded_logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  appLocalizations.welcome,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset('assets/images/google_logo.png'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        appLocalizations.sign_in_with_google,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EmailSignInPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 14, 112),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        appLocalizations.sign_in_with_email,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 180),
                // Ajout du texte "Pas encore de compte ?"
                Center(
                  child: Text(
                    appLocalizations.not_a_member, // Texte "Pas encore de compte ?"
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Espacement entre le texte et le bouton
                // Ajout du bouton "S'inscrire ici"
                Center(
                  child: InkWell(
                    onTap: () {
                      // Navigation vers la page d'inscription
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(), // Redirection vers la page d'inscription
                        ),
                      );
                    },
                    child: Text(
                      appLocalizations.sign_up, // Texte pour le bouton "S'inscrire ici"
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 255, 165, 69),
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
