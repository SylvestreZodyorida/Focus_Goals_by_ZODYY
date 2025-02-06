
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({Key? key}) : super(key: key);

  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  late User? _user;
  
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    // Vérifier la connexion Internet dès que la page est chargée
 
    // Écouter les changements de connectivité
    
  }

 
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // Rediriger l'utilisateur vers la page de connexion
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        user: _user,
        userName: _user?.displayName,
        userImageUrl: _user?.photoURL,
        onLogout: _logout,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Bienvenue dans votre routine!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cette page affichera votre planification et vos objectifs.',
              style: TextStyle(fontSize: 18),
            ),
            // Le contenu de ta page
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final String? userName;
  final String? userImageUrl;
  final VoidCallback onLogout;

  const CustomAppBar({
    Key? key,
    required this.user,
    required this.userName,
    required this.userImageUrl,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Couleur de fond personnalisée
      title: const Text(
        'Focus Goals by ZODYY ✨',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Vous pouvez ajouter une logique pour l'action à effectuer lors du clic sur l'avatar (par exemple, aller au profil)
            },
            child: _buildUserAvatar(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: onLogout, // Appel de la fonction de déconnexion
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    if (userImageUrl != null && userImageUrl!.isNotEmpty) {
      // Si l'utilisateur a une photo de profil
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(userImageUrl!),
        backgroundColor: Colors.transparent,
      );
    } else {
      // Si l'utilisateur n'a pas de photo, on affiche une icône par défaut
      return CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey.shade200,
        child: Image.asset(
          'assets/images/rounded_logo.png',
          fit: BoxFit.cover, // Cela garantit que l'image s'ajuste correctement dans le cercle
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
