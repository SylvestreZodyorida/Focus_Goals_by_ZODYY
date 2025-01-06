import 'package:flutter/material.dart';
import 'package:focus_goals_by_zodyy/pages/introduction/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus goals',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF18013E)),
        useMaterial3: true,
      ),
      home: const WelcomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
