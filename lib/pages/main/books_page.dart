  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:fg_by_zodyy/pages/custom_app_bar.dart';

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
                color: const Color.fromARGB(255, 255, 255, 255),
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
          'title': "Livre 1: La chèvre de ma mère",
          'author': 'Ricardo KANIAMA',
          'image': 'https://i.pinimg.com/474x/bc/08/fa/bc08fad490f96e31d15784f8e6c094f0.jpg',
          'downloadUrl': 'https://najibmikou.com/fr/wp-content/uploads/2021/03/La-chevre-de-ma-mere-Ricardo-KANIAMA.pdf', // Remplacez par l'URL de votre livre
        },
        {
          'title': "Livre 2: Réfléchissez et devenez riche",
          'author': 'Napoleon Hill',
          'image': 'https://i.pinimg.com/736x/ba/28/1c/ba281cfa415c096161180e3cab2d2098.jpg',
          'downloadUrl': 'https://livre21.com/LIVREF/F8/F008111.pdf', // Remplacez par l'URL de votre livre
        },

        {
          'title': "Livre 3 (Resumé--5 principes): Réfléchissez et devenez riche",
          'author': 'Napoleon Hill',
          'image': 'https://i.pinimg.com/736x/ba/28/1c/ba281cfa415c096161180e3cab2d2098.jpg',
          'downloadUrl': 'https://extrait.qublivre.ca/r60huyh69x0030bujfmvm2kcllk6', // Remplacez par l'URL de votre livre
        },
         {
          'title': "Livre 4: L'effet cumulé",
          'author': 'Darren Hardy',
          'image': 'https://i.pinimg.com/736x/3b/09/b6/3b09b6c96542e4519c9bb3b22b396dd0.jpg',
          'downloadUrl': 'https://www.fomesoutra.com/livres/developpement-personnel/8910-l-effet-cumule-darren-hardy/file', 
        },
        {
          'title': "Livre 5 (Livre audio): L'effet cumulé",
          'author': 'Darren Hardy',
          'image': 'https://i.pinimg.com/736x/3b/09/b6/3b09b6c96542e4519c9bb3b22b396dd0.jpg',
          'downloadUrl': 'https://open.spotify.com/episode/3S8IJrgYX6NOgImZBAe1pI?si=2vyWq1zKR-mkUoT9Pk3laQ' , 
        },
        {
          'title': "Livre 6 (Anglais): La règle du 10x",
          'author': 'Grant Cardone',
          'image': 'https://i.pinimg.com/736x/f3/9c/fd/f39cfd36f8f514db0eba6c2c2be2cb9f.jpg',
          'downloadUrl': 'https://ia801001.us.archive.org/31/items/10x_20191019/10X.pdf' , 
        },
        {
          'title': "Livre 6 (Français): La règle du 10x",
          'author': 'Grant Cardone',
          'image': 'https://i.pinimg.com/736x/f3/9c/fd/f39cfd36f8f514db0eba6c2c2be2cb9f.jpg',
          'downloadUrl': 'https://fr.scribd.com/document/623599374/null-6' , 
        },
            {
          'title': "Livre 7: La psychologie de l'argent",
          'author': 'Grant Cardone',
          'image': 'https://i.pinimg.com/736x/9c/c6/ae/9cc6ae6347ab896525cb55c872bd07c7.jpg',
          'downloadUrl': 'https://www.reseau-salariat.info/images/psychologie_de_l_argent_g._simmel.pdf' , 
        },
      ];

      return Scaffold(
        appBar: CustomAppBar(
          user: user,
          userName: _userName,
          userImageUrl: _userImageUrl,
          onLogout: () => _logout(context),
        ),
        backgroundColor: Colors.white, // Définit le fond en blanc
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "📚 Découvrez des livres inspirants pour votre développement personnel !",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      color: const Color.fromARGB(255, 253, 251, 249),
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: ListTile(
                        leading: Image.network(book['image']!),
                        title: Text(book['title']!),
                        subtitle: Text('Par ${book['author']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => _downloadBook(book['downloadUrl']!),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

      );

    }
  }
