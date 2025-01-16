import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur connecté
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil de l'utilisateur"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Se déconnecter
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login'); // Redirection vers la page de connexion
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator()) // Indicateur de chargement si l'utilisateur est null
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Affichage de l'image de profil
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.photoURL ?? ''),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Affichage du nom de l'utilisateur
                  Text(
                    'Nom : ${user.displayName ?? 'Non disponible'}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Affichage de l'email
                  Text(
                    'Email : ${user.email ?? 'Non disponible'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  // Affichage de l'UID
                  Text(
                    'ID utilisateur : ${user.uid}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
