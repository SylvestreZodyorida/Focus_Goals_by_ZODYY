import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({super.key, required this.title});

  final String title;

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  String selectedLanguage = "en"; // Langue par défaut : Anglais
  List<Map<String, String>> languages = [
    {"code": "en", "name": "English (US)", "flag": "🇺🇸"},
    {"code": "fr", "name": "Français", "flag": "🇫🇷"},
    {"code": "es", "name": "Español", "flag": "🇪🇸"},
    {"code": "de", "name": "Deutsch", "flag": "🇩🇪"},
    {"code": "it", "name": "Italiano", "flag": "🇮🇹"},
    {"code": "pt", "name": "Português", "flag": "🇵🇹"},
    {"code": "zh", "name": "中文", "flag": "🇨🇳"},
    {"code": "ar", "name": "العربية", "flag": "🇸🇦"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  // Charger la langue enregistrée
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selected_language') ?? "en";
    });
  }

  // Sauvegarder la langue sélectionnée
  Future<void> _saveSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2B5F),
      appBar: AppBar(
        title: const Text("Choose a language"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
            radius: 50,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLanguage = language['code']!;
                    });
                    _saveSelectedLanguage(language['code']!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedLanguage == language['code']
                          ? Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          language['flag']!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          language['name']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: selectedLanguage == language['code']
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                // Naviguer vers la prochaine page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NextPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Page"),
      ),
      body: const Center(
        child: Text("Welcome to the next page!"),
      ),
    );
  }
}
