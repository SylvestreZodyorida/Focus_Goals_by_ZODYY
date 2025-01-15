import 'package:fg_by_zodyy/pages/introduction/langues_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:fg_by_zodyy/pages/introduction/welcome_page.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:fg_by_zodyy/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialisation de Hive
  await Hive.openBox('settings'); // Ouvrir une boîte pour sauvegarder les paramètres
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageManager.languageNotifier,
      builder: (context, currentLanguage, child) {
        return MaterialApp(
          locale: Locale(currentLanguage),
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
            Locale('es'),
            Locale('de'),
            Locale('it'),
            Locale('pt'),
            Locale('zh'),
            Locale('ar'),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false, // Désactive la bannière DEBUG
          home: const SelectLanguagePage(),
        );
      },
    );
  }
}

class LanguageManager {
  static final ValueNotifier<String> _currentLanguage = ValueNotifier<String>(_loadInitialLanguage());

  /// Charge la langue initiale depuis Hive ou utilise "fr" par défaut
  static String _loadInitialLanguage() {
    final box = Hive.box('settings');
    return box.get('language', defaultValue: 'fr');
  }

  /// Retourne la langue actuelle
  static String getCurrentLanguage() => _currentLanguage.value;

  /// Définit la langue et la sauvegarde dans Hive
  static Future<void> setCurrentLanguage(String languageCode) async {
    _currentLanguage.value = languageCode;
    final box = Hive.box('settings');
    await box.put('language', languageCode); // Sauvegarde dans Hive
  }

  /// Retourne le `ValueNotifier` pour écouter les changements de langue
  static ValueNotifier<String> get languageNotifier => _currentLanguage;
}