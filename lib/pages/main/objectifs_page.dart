import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fg_by_zodyy/pages/custom_app_bar.dart';
import 'package:fg_by_zodyy/pages/custom_bottom_bar.dart';

class ObjectifsPage extends StatelessWidget {
  const ObjectifsPage({Key? key}) : super(key: key);

  // Fonction de déconnexion
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');  // Redirige vers la page de connexion
  }

  Future<void> _openModal(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          final List<Map<String, String>> items = [
            {'image': 'assets/images/icons/objectifs.jpg', 'text': 'Vos objectifs ✨', 'route': '/objectifs'},
            {'image': 'assets/images/icons/note.jpg', 'text': 'Vos notes 🗒️', 'route': '/notes'},
            {'image': 'assets/images/icons/lecture2.jpg', 'text': 'Lire un livre ', 'route': '/books'},
            {'image': 'assets/images/icons/applications.jpg', 'text': 'Applis utiles', 'route': '/apps'},
          ];

          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 241, 239, 252),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            child: Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.center,
              children: items.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(item['route']!);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(item['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['text']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String? _userName = user?.displayName;
    String? _userImageUrl = user?.photoURL;

    return Scaffold(
      appBar: CustomAppBar(
        user: user,
        userName: _userName,
        userImageUrl: _userImageUrl,
        onLogout: () => _logout(context), // Passer la fonction de déconnexion
      ),
      bottomNavigationBar: CustomBottomBar(openModal: () => _openModal(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openModal(context),
        backgroundColor: const Color.fromARGB(255, 255, 136, 0),
        child: const Icon(Icons.add_task_sharp, color:Color.fromARGB(255, 248, 248, 248)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: const Center(
        child: Text('Vos Objectifs ✨', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
