// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:fg_by_zodyy/pages/introduction/welcome_page.dart';
// import 'package:flutter_localizations/flutter_localizations.dart'; // Importer flutter_localizations
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation de la génération des traductions

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les bindings sont initialisés
//   await Hive.initFlutter(); // Initialisation de Hive
//   await LanguageManager.init(); // Initialisation de la gestion des langues
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Charger la langue sélectionnée
//     String currentLanguage = LanguageManager.getCurrentLanguage();

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Focus Goals',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF18013E)),
//         useMaterial3: true,
//       ),
//       locale: Locale(currentLanguage), // Appliquer la langue sélectionnée
//       supportedLocales: const [
//         Locale('fr'),
//         Locale('en'),
//         Locale('es'),
//         Locale('de'),
//         Locale('it'),
//         Locale('pt'),
//         Locale('zh'),
//         Locale('ar'),
//       ],
//       localizationsDelegates: [
//         AppLocalizations.delegate, // Délegate de traduction générée
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       home: const WelcomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class LanguageManager {
//   static late Box settingsBox;

//   // Initialisation de Hive
//   static Future<void> init() async {
//     settingsBox = await Hive.openBox('settings');
//   }

//   // Obtenir la langue actuelle (par défaut "fr")
//   static String getCurrentLanguage() {
//     return settingsBox.get('selected_language', defaultValue: "fr");
//   }

//   // Enregistrer la langue sélectionnée
//   static Future<void> setCurrentLanguage(String languageCode) async {
//     await settingsBox.put('selected_language', languageCode);
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fg_by_zodyy/pages/introduction/welcome_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Importer flutter_localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importation de la génération des traductions

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les bindings sont initialisés
  await Hive.initFlutter(); // Initialisation de Hive
  await LanguageManager.init(); // Initialisation de la gestion des langues
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Charger la langue sélectionnée
    String currentLanguage = LanguageManager.getCurrentLanguage();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus Goals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF18013E)),
        useMaterial3: true,
      ),
      locale: Locale(currentLanguage), // Appliquer la langue sélectionnée
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
      localizationsDelegates: [
        AppLocalizations.delegate, // Délegate de traduction générée
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const WelcomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class LanguageManager {
  static late Box settingsBox;

  // Initialisation de Hive
  static Future<void> init() async {
    settingsBox = await Hive.openBox('settings');
  }

  // Obtenir la langue actuelle (par défaut "fr")
  static String getCurrentLanguage() {
    return settingsBox.get('selected_language', defaultValue: "fr");
  }

  // Enregistrer la langue sélectionnée
  static Future<void> setCurrentLanguage(String languageCode) async {
    await settingsBox.put('selected_language', languageCode);
  }
}
