
import 'package:fg_by_zodyy/pages/custom_app_bar.dart';
import 'package:fg_by_zodyy/pages/custom_bottom_bar.dart';
// import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hive_flutter/hive_flutter.dart';
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

  final List<Map<String, dynamic>> emotions = [
    {
      'name': 'Joie',
      'icon': Icons.sentiment_satisfied_alt,
      'color': Colors.yellow,
      'message': 'Profite pleinement de ce moment positif ! 🎉',
      'imageUrl': 'https://i.pinimg.com/736x/e3/b2/07/e3b2075e1222666452aa618894dd8f7d.jpg', // Exemple d'image
      'actions': ['Noter un bon souvenir', 'Partager une réussite', 'Exprimer sa gratitude'],
      'link': 'https://www.youtube.com/results?search_query=joie+motivation',
    },
    {
      'name': 'Tristesse',
      'icon': Icons.sentiment_dissatisfied,
      'color': Colors.blue,
      'message': 'Prends soin de toi, cette période va passer. 💙',
      'imageUrl': 'https://i.pinimg.com/474x/25/0e/ad/250ead664e7602dc51d11669187b9b53.jpg', // Exemple d'image
      'actions': ['Écouter une musique relaxante', 'Lire une citation inspirante', 'Écrire ses pensées'],
      'link': 'https://www.youtube.com/results?search_query=surmonter+la+tristesse',
    },
    {
      'name': 'Stress',
      'icon': Icons.sentiment_neutral,
      'color': Colors.orange,
      'message': 'Respire profondément et prends du recul. 🧘‍♂️',
      'imageUrl': 'https://i.pinimg.com/474x/44/c1/cb/44c1cbbe3536e4f388736a5743e1e642.jpg', // Exemple d'image
      'actions': ['Faire un exercice de respiration', 'Lister les priorités', 'Méditer quelques minutes'],
      'link': 'https://www.youtube.com/results?search_query=gestion+du+stress',
    },
    {
      'name': 'Colère',
      'icon': Icons.mood_bad,
      'color': Colors.red,
      'message': 'Respire, éloigne-toi un instant et relâche la pression. 🔥',
      'imageUrl': 'https://i.pinimg.com/474x/df/dd/68/dfdd68337e8e0df46be5f89f9816dd2e.jpg', // Exemple d'image
      'actions': ['Écrire ce qui m’énerve', 'Écouter de la musique apaisante', 'Prendre une pause'],
      'link': 'https://www.youtube.com/results?search_query=comment+g%C3%A9rer+la+col%C3%A8re',
    },
    {
      'name': 'Peur',
      'icon': Icons.sentiment_very_dissatisfied,
      'color': Colors.purple,
      'message': 'Affronte tes peurs progressivement et en douceur. 💜',
      'imageUrl': 'https://fr.pinterest.com/pin/3096293489533320/', // Exemple d'image
      'actions': ['Visualiser un scénario positif', 'Parler de sa peur à quelqu’un', 'Pratiquer la relaxation'],
      'link': 'https://www.youtube.com/results?search_query=surmonter+la+peur',
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            alignment: WrapAlignment.center,
            children: emotions.map((emotion) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmotion = emotion['name'];
                    emotionMessage = emotion['message'];
                    suggestedActions = List<String>.from(emotion['actions']);
                    externalLink = emotion['link'];
                    emotionImageUrl = emotion['imageUrl']; // Mise à jour de l'URL de l'image
                  });
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: emotion['color'],
                      radius: 30,
                      child: Icon(emotion['icon'], size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      emotion['name'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
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
        backgroundColor: const Color.fromARGB(255, 255, 136, 0),
        child: const Icon(Icons.add_reaction, color: Color.fromARGB(255, 248, 248, 248)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectedEmotion == null
            ? const Center(child: Text("Sélectionne une émotion pour voir les suggestions."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tu ressens : $selectedEmotion", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(emotionMessage ?? '', style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 20),
                  emotionImageUrl != null 
                      ? Image.network(emotionImageUrl!) // Affichage de l'image dynamique
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (externalLink != null) {
                        await launchUrl(Uri.parse(externalLink!));
                      }
                    },
                    child: const Text("Voir des ressources"),
                  ),
                ],
              ),
      ),
    );
  }
}
