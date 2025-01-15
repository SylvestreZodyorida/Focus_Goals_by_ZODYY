import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import de la classe générée par l10n
import 'package:fg_by_zodyy/main.dart'; // Import du gestionnaire de langues

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Fonction d'inscription avec Google
  Future<void> _signUpWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      // Une fois l'inscription réussie, vous pouvez rediriger vers une autre page
      // Par exemple : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (error) {
      print(error);
    }
  }

  // Fonction d'inscription avec Email
  void _signUpWithEmail() {
    // Vous pouvez ici ajouter la logique pour vous inscrire avec un email (par exemple, utiliser Firebase Auth).
    // Pour simplifier, on va juste rediriger vers une autre page.
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la langue actuelle avec AppLocalizations
    String currentLanguage = LanguageManager.getCurrentLanguage();
    Locale currentLocale = Locale(currentLanguage); // Créez le Locale en fonction de la langue

    // Vérifiez si la localisation est bien disponible
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()), // Affiche un indicateur de chargement si la localisation n'est pas disponible
      );
    }

    return Scaffold(
      // Pas d'AppBar
      body: Stack(
        children: [
          // Image d'arrière-plan, ajustée pour couvrir tout l'écran
          Positioned.fill(
            child: Image.asset(
              'assets/images/fond.png', // Votre image d'arrière-plan ici
              fit: BoxFit.cover,
            ),
          ),
          // Le contenu de la page
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Rapproche les éléments vers le haut
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 140), // Réduit l'espacement entre le haut de l'écran et le logo
                // Envelopper l'image du logo avec ClipRRect pour les bords arrondis
                ClipRRect(
                  borderRadius: BorderRadius.circular(90), // Définir le rayon d'arrondi ici
                  child: Image.asset(
                    'assets/images/rounded_logo.png',
                    height: 100, // Taille du logo
                  ),
                ),
                const SizedBox(height: 10), // Espace entre le logo et le texte
                Text(
                  appLocalizations.sign_up, // Traduction pour "S'inscrire"
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 80), // Espacement entre le texte et les boutons
                ElevatedButton(
                  onPressed: _signUpWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_circle, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        appLocalizations.sign_up_with_google, // Traduction pour "S'inscrire avec Google"
                        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Espacement entre les boutons
                ElevatedButton(
                  onPressed: _signUpWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 14, 112),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        appLocalizations.sign_up_with_email, // Traduction pour "S'inscrire avec Email"
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 180),
                // Ajout du texte "Pas encore de compte ?"
                Center(
                  child: Text(
                    appLocalizations.already_a_member, // Texte "Pas encore de compte ?"
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
                      // Navigation vers la page de connexion
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(), // Redirection vers la page de connexion
                        ),
                      );
                    },
                    child: Text(
                      appLocalizations.login, // Texte pour le bouton "Se connecter ici"
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
