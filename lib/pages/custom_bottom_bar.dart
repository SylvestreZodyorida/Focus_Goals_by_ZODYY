import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback openModal; // Fonction pour ouvrir le modal

  const CustomBottomBar({Key? key, required this.openModal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color:  Color.fromARGB(235, 255, 255, 255),

      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            iconSize: 40,
            color: const Color.fromARGB(255, 25, 25, 25),

            onPressed: () {
              Navigator.pushNamed(context, '/home'); // Exemple de navigation
            },
          ),
          // Espaces flexibles pour aligner à droite
          Spacer(),
          IconButton(
            icon: const Icon(Icons.settings),
            color: const Color.fromARGB(255, 25, 25, 25),

              iconSize: 40,
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); // Exemple de navigation
            },
          ),
        ],
      ),
    );
  }
}
