import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fg_by_zodyy/main.dart'; // Import du gestionnaire de langues

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({super.key});

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  String selectedLanguage = LanguageManager.getCurrentLanguage();

  List<Map<String, String>> languages = [
    {"code": "fr", "name": "Français", "flag": "🇫🇷"},
    {"code": "en", "name": "English (US)", "flag": "🇺🇸"},
    {"code": "es", "name": "Español", "flag": "🇪🇸"},
    {"code": "de", "name": "Deutsch", "flag": "🇩🇪"},
    {"code": "it", "name": "Italiano", "flag": "🇮🇹"},
    {"code": "pt", "name": "Português", "flag": "🇵🇹"},
    {"code": "zh", "name": "中文", "flag": "🇨🇳"},
    {"code": "ar", "name": "العربية", "flag": "🇸🇦"},
  ];

  Future<void> _updateLanguage(String languageCode) async {
    setState(() {
      selectedLanguage = languageCode;
    });
    await LanguageManager.setCurrentLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fond.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
                radius: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                "Choisir une langue",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected = selectedLanguage == language['code'];
                    return GestureDetector(
                      onTap: () => _updateLanguage(language['code']!),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              language['flag']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              language['name']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.black : Colors.white,
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
                    // Redirige vers la page suivante après la sélection de la langue
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(), // Redirection vers la page NextPage
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Continuer",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
