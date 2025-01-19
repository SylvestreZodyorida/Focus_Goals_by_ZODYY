import 'package:fg_by_zodyy/pages/main/objectifs_page.dart';
import 'package:fg_by_zodyy/pages/main/applications_page.dart';
import 'package:fg_by_zodyy/pages/main/books_page.dart';
import 'package:fg_by_zodyy/pages/main/notes_page.dart';
import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fg_by_zodyy/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Firebase.initializeApp();
  
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
          supportedLocales: _supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false,
          home: const HomePage(), // Page redirigée directement vers HomePage
           routes: {
            '/objectifs': (context) => ObjectifsPage(),
            '/notes': (context) => NotesPage(),
            '/books': (context) => BooksPage(),
            '/apps': (context) => ApplicationsPage(),
            '/home': (context) => HomePage(),
            '/settings': (context) => HomePage(),
            '/login': (context) => LoginPage(),
          },
        );
      },
    );
  }

  static const List<Locale> _supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('es'),
    Locale('de'),
    Locale('it'),
    Locale('pt'),
    Locale('zh'),
    Locale('ar'),
  ];
}

class LanguageManager {
  static final ValueNotifier<String> _currentLanguage = ValueNotifier<String>(_loadInitialLanguage());

  static String _loadInitialLanguage() {
    final box = Hive.box('settings');
    String language = box.get('language', defaultValue: 'fr');
    print('Langue initiale chargée : $language'); // Affichage de la langue initiale
    return language;
  }

  static String getCurrentLanguage() => _currentLanguage.value;

  static Future<void> setCurrentLanguage(String languageCode) async {
    _currentLanguage.value = languageCode;
    final box = Hive.box('settings');
    await box.put('language', languageCode); // Sauvegarde la langue
    print('Langue définie : $languageCode'); // Affichage lors de la modification de la langue
  }

  static ValueNotifier<String> get languageNotifier => _currentLanguage;
}
