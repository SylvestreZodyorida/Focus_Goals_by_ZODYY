import 'package:fg_by_zodyy/pages/main/emotion_page.dart';
import 'package:fg_by_zodyy/pages/main/notes_page.dart';
import 'package:fg_by_zodyy/pages/main/objectifs_page.dart';
import 'package:fg_by_zodyy/pages/main/routine_page.dart';
import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fg_by_zodyy/pages/introduction/langues_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final slider.CarouselSliderController _carouselController = slider.CarouselSliderController();
  final User? user = FirebaseAuth.instance.currentUser;
   final String _selectedLanguage = 'fr'; // Vous pouvez changer cette langue dynamiquement
  // bool _isLoading = true;
  String? _userName;
  String? _userImageUrl;
    int completedTasks = 0;
  int totalTasks = 0;
  double completionRate = 0.0;

  int _currentSlide = 0;

  final List<String> _quotes = [
    '"Votre temps est limité, ne le gâchez pas en vivant la vie de quelqu\'un d\'autre." - Steve Jobs',
    '"Le succès n\'est pas final, l\'échec n\'est pas fatal : c\'est le courage de continuer qui compte." - Winston Churchill',
    '"Commencez où vous êtes. Utilisez ce que vous avez. Faites ce que vous pouvez." - Arthur Ashe',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _checkUserLogin();
      _fetchObjectiveData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _openModal(); // Ouvrir le modal après que le contexte soit disponible
  }

  Future<void> _loadUserProfile() async {
    if (user != null) {
      setState(() {
        _userName = user?.displayName;
        _userImageUrl = user?.photoURL;
      });
    }
  }
  List<Map<String, dynamic>> blocData = [
        {
          'image': 'assets/images/home_objectifs.jpg',
          'text': 'Vos Ojectifs',
          'textColor': const Color.fromARGB(255, 10, 10, 10), 
          'page': const ObjectifsPage(),
        },
        {
          'image': 'assets/images/home_emotion.jpg',
          'text': 'Gérer une émotion',
          'textColor': const Color.fromARGB(255, 10, 10, 10), 
          'page': const EmotionPage(),
        },
        {
          'image': 'assets/images/home_routine.jpg',
          'text': 'Routine journalière',
          'textColor': const Color.fromARGB(255, 10, 10, 10), 
          'page': const RoutinePage(),
        },
        {
          'image': 'assets/images/home_notes.jpg',
          'text': 'Ajouter une note',
          'textColor': const Color.fromARGB(255, 10, 10, 10), 
          'page': const NotesPage(),
        },
          {
          'image': 'assets/images/icons/lecture2.jpg',
          'text': 'Lire un livre ',
          'textColor': const Color.fromARGB(255, 10, 10, 10), 
          'page': const NotesPage(),
        },

        {
          'image': 'assets/images/icons/manger.jpg',
          'text': 'Bien manger',
          'textColor': const Color.fromARGB(255, 10, 10, 10), 
          'page': const NotesPage(),
        },

        {
          'image': 'assets/images/icons/sport.jpg',
          'text': 'Activité physique',
          'textColor': const Color.fromARGB(255, 10, 10, 10), 
          'page': const NotesPage(),
        },

        // {
        //   'image': 'assets/images/home_notes.jpg',
        //   'text': 'Applications utilles',
        //   'textColor': const Color.fromARGB(255, 10, 10, 10), 
        //   'page': const NotesPage(),
        // },
      ];
      
  Future<void> _checkUserLogin() async {
    final box = await Hive.openBox('settings');
    final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);


    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectLanguagePage()),
      );
    }else {
      _openModal(context);
    }
     // Ouvrir le modal après que le contexte soit disponible

  }
  Future<void> _refreshPage() async {
    await _loadUserProfile();
    setState(() {});
  }

Future<void> _fetchObjectiveData() async {
    // Récupérer les données de la collection "objectives" depuis Firebase
    final snapshot = await FirebaseFirestore.instance.collection('objectives').get();

    int completed = 0;
    int total = snapshot.docs.length;

    // Parcourir les documents et compter les objectifs terminés
    for (var doc in snapshot.docs) {
      if (doc['status'] == 'completed') {
        completed++;
      }
    }

    // Mettre à jour les variables d'état
    setState(() {
      completedTasks = completed;
      totalTasks = total;
      completionRate = total > 0 ? completed / total : 0.0; // Éviter la division par 0
    });
  }

  double completionRateBooks = 0.50; // Exemple : 75%
      int completedBooks = 5; // Nombre de tâches complétées (variable dynamique)
      int totalBooks = 10;

  Future<void> _openModal(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color.fromARGB(255, 240, 240, 242),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Focus Goals by ZODYY ✨",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(235, 15, 15, 15) ),
                ),
                const SizedBox(height: 8),

                // Container(
                //     margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                //     padding: const EdgeInsets.all(15.0),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(15.0),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.3),
                //           spreadRadius: 2,
                //           blurRadius: 5,
                //           offset: const Offset(0, 3), // décalage de l'ombre
                //         ),
                //       ],
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Text(
                //           "✔️ Vos objectifs",
                //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //         ),
                //         const SizedBox(height: 8),
                //       // Nombre total de tâches (variable dynamique)
                //         Row(
                //           children: [
                //             Text(
                //               "${(completedTasks / totalTasks * 100).toStringAsFixed(0)}%", // Affiche le pourcentage calculé
                //               style: const TextStyle(
                //                 fontSize: 24,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),

                //             Spacer(),

                //             const SizedBox(width: 8),
                //             Text(
                //               "$completedTasks/$totalTasks atteints", // Affiche le ratio dynamique
                //               style: const TextStyle(
                //                 color: Color.fromARGB(255, 228, 102, 5),
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ],
                //         ),

                //         const SizedBox(height: 8),
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(8),
                //           child: LinearProgressIndicator(
                //             value: completionRateBooks, // La valeur est mise à jour dynamiquement
                //             backgroundColor: Colors.grey[300],
                //             color: Colors.green,
                //             minHeight: 8,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),


Container(
  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
  padding: const EdgeInsets.all(15.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3), // décalage de l'ombre
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "✔️ Vos objectifs",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      // Nombre total de tâches (variable dynamique)
      Row(
        children: [
          Text(
            "${(completionRate * 100).toStringAsFixed(0)}%", // Affiche le pourcentage calculé
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          const SizedBox(width: 8),
          Text(
            "$completedTasks/$totalTasks atteints", // Affiche le ratio dynamique
            style: const TextStyle(
              color: Color.fromARGB(255, 228, 102, 5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: completionRate, // La valeur est mise à jour dynamiquement
          backgroundColor: Colors.grey[300],
          color: Colors.green,
          minHeight: 8,
        ),
      ),
    ],
  ),
),



                  const SizedBox(height: 10),
                
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // décalage de l'ombre
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📚 Lecture",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      
                      const SizedBox(height: 8),
                          // Nombre total de tâches (variable dynamique)
                      Row(
                        children: [
                          Text(
                            "${(completedBooks / totalBooks * 100).toStringAsFixed(0)}%", // Affiche le pourcentage calculé
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            Spacer(),

                          const SizedBox(width: 8),
                          Text(
                            "$completedBooks/$totalBooks livres lus", // Affiche le ratio dynamique
                            style: const TextStyle(
                              color: Color.fromARGB(255, 228, 102, 5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: completionRate, // La valeur est mise à jour dynamiquement
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          );
        },
      );
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Couleur de fond personnalisée
      elevation: 0, // Ombre de l'AppBar (peut être ajustée ou mise à 0)
      title: const Text(
        'Focus Goals by ZODYY ✨',
        style: TextStyle(
          color: Color.fromARGB(255, 8, 8, 8), // Couleur du texte
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Color.fromARGB(255, 228, 191, 6), // Couleur de l'icône
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              backgroundImage: _userImageUrl != null
                  ? NetworkImage(_userImageUrl!)
                  : const AssetImage('assets/images/rounded_logo.png') as ImageProvider,
            ),
          ),
        ),
      ],
    ),

    drawer: Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 1, 6, 61),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: _userImageUrl != null
                      ? NetworkImage(_userImageUrl!)
                      : const AssetImage('assets/images/rounded_logo.png') as ImageProvider,
                  radius: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  _userName ?? 'User Name',
                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(_userName ?? 'User Name', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          // ListTile(
          //   leading: const Icon(Icons.edit),
          //   title: Text(AppLocalizations.of(context)!.reset_password, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.image_sharp),
            title: Text("Fond d'écran pour votre android", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner_sharp),
            title: Text("A propos", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.coffee),
            title: Text("Bye me a coffee", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app), // Icône de déconnexion
            title: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onTap: () async {
              await FirebaseAuth.instance.signOut(); // Déconnexion de l'utilisateur
              // Redirection vers la page de login après déconnexion
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), // Remplacer LoginPage par ta page de connexion
              );
            },
          ),
        ],
      ),
    ),

    body: Container(
      color: const Color.fromARGB(255, 255, 255, 255), 
      // Couleur de fond personnalisée
      child: RefreshIndicator(
        
        onRefresh: _refreshPage,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  slider.CarouselSlider(
                    carouselController: _carouselController,
                    options: slider.CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 9),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlide = index;
                        });
                      },
                    ),
                    items: _quotes.map((quote) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 245, 245, 245),
                                  Color.fromARGB(255, 231, 232, 231),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.2),
                              //     offset: Offset(0, 4),
                              //     blurRadius: 6,
                              //     spreadRadius: 2,
                              //   ),
                              // ],
                            ),
                            child: Center(
                              child: Text(
                                quote,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
           SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20), // Marges extérieures
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10, // Espacement horizontal entre les blocs
                  mainAxisSpacing: 30, // Espacement vertical entre les blocs
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    String imagePath = blocData[index]['image']!;
                    String text = blocData[index]['text']!;
                    Widget page = blocData[index]['page'];
                    Color textColor = blocData[index]['textColor'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => page,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all( 9.0),

                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 216, 216, 216),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            ClipRRect(
                              
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                imagePath,
                                width: double.infinity,
                                height: 95,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 05),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: blocData.length,
                ),
              ),
            ),

          ],
        ),
      ),
    ),

    bottomNavigationBar: BottomAppBar(
      color:  const Color.fromARGB(235, 255, 255, 255),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: const Color.fromARGB(255, 25, 25, 25),
            iconSize: 40,
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 40,
            color: const Color.fromARGB(255, 25, 25, 25),
            onPressed: () {},
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _openModal(context),
       backgroundColor: const Color.fromARGB(255, 255, 136, 0),
        child: const Icon(Icons.add_task_sharp, color:Color.fromARGB(255, 248, 248, 248)),
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}
