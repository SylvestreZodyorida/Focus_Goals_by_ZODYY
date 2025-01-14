import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Importation de hive_flutter
import 'package:fg_by_zodyy/pages/introduction/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les bindings sont initialisés
  await Hive.initFlutter(); // Initialisation de Hive
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus Goals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF18013E)),
        useMaterial3: true,
      ),
      home: const WelcomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
