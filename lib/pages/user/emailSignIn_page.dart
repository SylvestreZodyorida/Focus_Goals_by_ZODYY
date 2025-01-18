


import 'package:fg_by_zodyy/pages/user/signUp_page.dart';
import 'package:fg_by_zodyy/pages/user/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import de la classe générée par l10n
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import de Hive
import 'package:fg_by_zodyy/pages/user/signUp_page.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({super.key});

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Box? userBox;

  @override
  void initState() {
    super.initState();
    // Initialisation de Hive
    Hive.initFlutter();
    // Ouverture de la box Hive pour les données utilisateur
    Hive.openBox('userBox').then((box) {
      userBox = box;
    });
  }

  void _signInWithEmail() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        // Ouvrir la boîte Hive pour mettre à jour les informations de l'utilisateur
        var box = await Hive.openBox('settings');
        
        // Enregistrer l'email dans Hive après connexion réussie
        await box.put('email', email);

        // Mettre à jour l'état de connexion dans Hive
        await box.put('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } catch (e) {
      String errorMessage = 'Erreur de connexion';

      // Gestion des erreurs Firebase spécifiques
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Aucun utilisateur trouvé avec cet email.';
            break;
          case 'wrong-password':
            errorMessage = 'Mot de passe incorrect.';
            break;
          case 'invalid-email':
            errorMessage = 'Email invalide.';
            break;
          case 'network-request-failed':
            errorMessage = 'Problème de connexion. Veuillez vérifier votre réseau.';
            break;
          default:
            errorMessage = 'Une erreur inconnue s\'est produite. Essayez à nouveau.';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.login)),
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 11, 3, 44), // Fond bleu
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.asset(
                      'assets/images/rounded_logo.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Bloc arrondi avec fond blanc légèrement transparent
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.email,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.password,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _signInWithEmail,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            backgroundColor: const Color.fromARGB(255, 2, 10, 90),
                          ),
                          child: Text(
                            appLocalizations.sign_in,
                            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 180),
                  // Ajout du texte "Pas encore de compte ?"
                  Center(
                    child: Text(
                      appLocalizations.not_a_member,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: Text(
                        appLocalizations.sign_up,
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
          ),
        ],
      ),
    );
  }
}
