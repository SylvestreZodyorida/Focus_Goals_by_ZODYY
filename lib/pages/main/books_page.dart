import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

  // Fonction de déconnexion
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Redirige vers la page de connexion
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

  Future<void> _downloadBook(String bookUrl) async {
    if (await canLaunch(bookUrl)) {
      await launch(bookUrl); // Lance l'URL du fichier PDF pour le téléchargement
    } else {
      throw 'Impossible d\'ouvrir le lien';
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String? _userName = user?.displayName;
    String? _userImageUrl = user?.photoURL;

    // Liste de livres (avec une URL de téléchargement pour chaque livre)
    final List<Map<String, String>> books = [
      {
        'title': 'Livre 1: Développement Personnel',
        'author': 'Auteur 1',
        'image': 'assets/images/books/book1.jpg',
        'downloadUrl': 'https://example.com/book1.pdf', // Remplacez par l'URL de votre livre
      },
      {
        'title': 'Livre 2: Croissance Personnelle',
        'author': 'Auteur 2',
        'image': 'assets/images/books/book2.jpg',
        'downloadUrl': 'https://example.com/book2.pdf',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Livres de Développement Personnel'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: Image.asset(book['image']!),
              title: Text(book['title']!),
              subtitle: Text('Par ${book['author']}'),
              trailing: IconButton(
                icon: Icon(Icons.download),
                onPressed: () => _downloadBook(book['downloadUrl']!),
              ),
            ),
          );
        },
      ),
    );
  }
}
