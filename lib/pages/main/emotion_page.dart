
import 'package:fg_by_zodyy/pages/custom_app_bar.dart';
import 'package:fg_by_zodyy/pages/custom_bottom_bar.dart';
import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
class EmotionPage extends StatefulWidget {
  const EmotionPage({Key? key}) : super(key: key);

  @override
  _EmotionPageState createState() => _EmotionPageState();
}

class _EmotionPageState extends State<EmotionPage> {
  String? selectedEmotion;
  String? emotionMessage;
  List<String>? suggestedActions;
  String? externalLink;
  String? emotionImageUrl; // Ajout d'un champ pour l'URL de l'image

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openEmotionModal(context);
    });
  }

 final List<Map<String, dynamic>> emotions = [
  {
    'name': 'Joie',
    'icon': Icons.sentiment_satisfied_alt,
    'color': Colors.yellow,
    'message': 'Profite pleinement de ce moment positif ! 🎉',
    'imageUrl': 'assets/images/joie.jpg', // Chemin local
    'actions': ['Noter un bon souvenir', 'Partager une réussite', 'Exprimer sa gratitude'],
  },
  {
    'name': 'Tristesse',
    'icon': Icons.sentiment_dissatisfied,
    'color': Colors.blue,
    'message': 'Prends soin de toi, cette période va passer. 💙',
    'imageUrl': 'assets/images/tristesse.jpg',
    'actions': ['Écouter une musique relaxante', 'Lire une citation inspirante', 'Écrire ses pensées'],
  },
  {
    'name': 'Stress',
    'icon': Icons.sentiment_neutral,
    'color': Colors.orange,
    'message': 'Respire profondément et prends du recul. 🧘‍♂️',
    'imageUrl': 'assets/images/stress.jpg',
    'actions': ['Faire un exercice de respiration', 'Lister les priorités', 'Méditer quelques minutes'],
  },
  {
    'name': 'Colère',
    'icon': Icons.mood_bad,
    'color': Colors.red,
    'message': 'Respire, éloigne-toi un instant et relâche la pression. 🔥',
    'imageUrl': 'assets/images/colere.jpg',
    'actions': ['Écrire ce qui m’énerve', 'Écouter de la musique apaisante', 'Prendre une pause'],
  },
  {
    'name': 'Peur',
    'icon': Icons.sentiment_very_dissatisfied,
    'color': Colors.purple,
    'message': 'Affronte tes peurs progressivement et en douceur. 💜',
    'imageUrl': 'assets/images/peur.jpg',
    'actions': ['Visualiser un scénario positif', 'Parler de sa peur à quelqu’un', 'Pratiquer la relaxation'],
  },
];


  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _openEmotionModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 24, 23, 23),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Comment te sens-tu aujourd'hui ?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15), // Espacement entre le texte et la liste
              ...emotions.map((emotion) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: emotion['color'].withOpacity(0.2), // Changement du fond
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: emotion['color'],
                      child: Icon(emotion['icon'], color: Colors.white),
                    ),
                    title: Text(
                      emotion['name'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        selectedEmotion = emotion['name'];
                        emotionMessage = emotion['message'];
                        suggestedActions = List<String>.from(emotion['actions']);
                        externalLink = emotion['link'];
                        emotionImageUrl = emotion['imageUrl'];
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
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
        onLogout: () => _logout(context),
      ),
      bottomNavigationBar: CustomBottomBar(openModal: () => _openEmotionModal(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEmotionModal(context),
        backgroundColor: const Color.fromARGB(255, 49, 48, 48),
        child: const Icon(Icons.add_reaction, color: Color.fromARGB(255, 255, 255, 255)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        color: const Color.fromARGB(255, 16, 16, 16),
        padding: const EdgeInsets.all(16.0),
        child: selectedEmotion == null
            ? const Center(
                child: Text(
                  "Sélectionne une émotion pour voir les suggestions.",
                  style: TextStyle(color: Color.fromARGB(255, 255, 98, 0)),
                ),
              )
            : SingleChildScrollView( // Ajout de SingleChildScrollView pour activer le scroll
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    
                    Text(
                      "Tu ressens : $selectedEmotion",
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      emotionMessage ?? '',
                      style: const TextStyle(
                        fontSize: 18, 
                        fontStyle: FontStyle.italic, 
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Actions suggérées :",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...suggestedActions!.map((action) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "- $action",
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        )),
                    
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (externalLink != null) {
                          await launchUrl(Uri.parse(externalLink!));
                        }
                      },
                      child: const Text("Voir des ressources"),
                    ),
                    const SizedBox(height: 20),

                    if (emotionImageUrl != null)
                      Image.asset(emotionImageUrl!), // Affichage de l'image dynamique
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),


    );
  }
}
