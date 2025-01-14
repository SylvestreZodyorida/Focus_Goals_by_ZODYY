import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF18013E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png', height: 100), // Utilisation d'Image au lieu de CircleAvatar avec const
            const SizedBox(height: 30),
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Couleur du bouton Google
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.account_circle, color: Colors.white), // Remplacé par une icône générique
                  SizedBox(width: 10),
                  Text(
                    "Sign in with Google",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Couleur du bouton email
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.email, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Sign in with Email",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
