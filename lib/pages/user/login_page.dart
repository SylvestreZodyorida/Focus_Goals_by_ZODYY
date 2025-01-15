import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import de la classe générée par l10n
import 'package:fg_by_zodyy/main.dart'; // Import du gestionnaire de langues

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Fonction de connexion avec Google
  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      // Une fois la connexion réussie, vous pouvez rediriger vers une autre page
      // Par exemple : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (error) {
      print(error);
    }
  }

  // Fonction de connexion avec Email
  void _signInWithEmail() {
    // Vous pouvez ici ajouter la logique pour vous connecter avec un email (par exemple, utiliser Firebase Auth).
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
              // L'image couvre tout l'écran
            ),
          ),
          // Le contenu de la page
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Rapproche les éléments vers le haut
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40), // Réduit l'espacement entre le haut de l'écran et le logo
                // Envelopper l'image du logo avec ClipRRect pour les bords arrondis
                ClipRRect(
                  borderRadius: BorderRadius.circular(90), // Définir le rayon d'arrondi ici
                  child: Image.asset(
                    'assets/images/rounded_logo.png',
                    height: 100, // Taille du logo
                  ),
                ),
                const SizedBox(height: 30), // Espace entre le logo et le texte
                Text(
                  appLocalizations.welcome, // Traduction pour "Bienvenue"
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30), // Espacement entre le texte et les boutons
                ElevatedButton(
                  onPressed: _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 144, 6),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_circle, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        appLocalizations.sign_in_with_google, // Traduction pour "Se connecter avec Google"
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Espacement entre les boutons
                ElevatedButton(
                  onPressed: _signInWithEmail,
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
                        appLocalizations.sign_in_with_email, // Traduction pour "Se connecter avec Email"
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Ajout de la section "Pas encore de compte ? S'inscrire ici"
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
                      appLocalizations.sign_up, // Traduction pour "Pas encore de compte ? S'inscrire ici"
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Page d'inscription avec un rendu similaire à la page de connexion
    return Scaffold(
      body: Stack(
        children: [
          // Image d'arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/images/fond.png', // Votre image d'arrière-plan ici
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    'assets/images/rounded_logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'S\'inscrire', // Titre pour la page d'inscription
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Ajoutez ici les champs de formulaire pour l'inscription (email, mot de passe, etc.)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
