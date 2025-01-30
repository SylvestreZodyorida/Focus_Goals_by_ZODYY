

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fg_by_zodyy/pages/custom_app_bar.dart';
import 'package:fg_by_zodyy/pages/custom_bottom_bar.dart';
import 'package:intl/intl.dart';


class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _addNote(String title, String description,) async {
    if (user == null || title.isEmpty || description.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs correctement.')),
      );
      return;
    }



    final notesCollection = firestore.collection('notes');
    await notesCollection.add({
      'userId': user!.uid,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context); // Fermer le modal après ajout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note ajouté avec succès.')),
    );
  }

  Future<void> _openModalAdd(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true, // Permet de fermer en cliquant à l'extérieur
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter, // Place la boîte en haut de l'écran
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0), // Ajoute des marges externes
            child: Material(
              color: Colors.transparent, // Fond transparent pour gérer l'arrondi
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Arrondi les bords du modal
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Couleur du fond
                        borderRadius: BorderRadius.circular(20.0), // Bord arrondi
                      ),
                      width: double.infinity, // Prend toute la largeur disponible
                      height: MediaQuery.of(context).size.height * 0.50, // Hauteur définie (70% de l'écran)
                      padding: const EdgeInsets.all(16.0),
                      child: ModalContent(
                        controller: ScrollController(), // Ajout du controller ici
                        onAddNote: _addNote,
                      ),
                    ),

                    // Bouton de fermeture
                    Positioned(
                      top: 10, // Position depuis le haut
                      right: 10, // Position depuis la droite
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(), // Ferme le modal
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 3, 159, 1), // Fond orange
                            shape: BoxShape.circle, // Bouton rond
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 24), // Croix blanche
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? _userName = user?.displayName;
    String? _userImageUrl = user?.photoURL;

    return Scaffold(
      appBar: CustomAppBar(
        user: user,
        userName: _userName,
        userImageUrl: _userImageUrl,
        onLogout: () => _logout(context),
      ),
      bottomNavigationBar: CustomBottomBar(openModal: () => _openModalAdd(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openModalAdd(context),
        backgroundColor: Color.fromARGB(255, 3, 159, 1),
        child: const Icon(Icons.add_task_sharp, color: Color.fromARGB(255, 248, 248, 248)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 3, 159, 1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Vos Notes ✨',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('notes')
                      .where('userId', isEqualTo: user?.uid)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur de chargement des Notes: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucune Note trouvé. Ajoutez-en un nouveau ✨',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      );
                    }

                    final notes = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final data = notes[index].data() as Map<String, dynamic>;

                        // Vérifier si 'createdAt' est présent et n'est pas null
                        if (data['createdAt'] != null) {
                          Timestamp timestamp = data['createdAt'];
                          DateTime createdAt = timestamp.toDate();
                          String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

                          final cardColor = index % 2 == 0
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 247, 221, 207);

                          return Card(
                            color: cardColor,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(data['title'] ?? 'Sans titre', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data['description'] != null)
                                    Text(data['description'], style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text('Date de création: $formattedDate', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                                onPressed: () async {
                                  await notes[index].reference.delete();
                                },
                              ),
                            ),
                          );
                        } else {
                          // Si 'createdAt' est null, afficher un message alternatif
                          return Card(
                            color: index % 2 == 0
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : const Color.fromARGB(255, 247, 221, 207),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(data['title'] ?? 'Sans titre', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data['description'] != null)
                                    Text(data['description'], style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text('Date de création: Indisponible', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                                onPressed: () async {
                                  await notes[index].reference.delete();
                                },
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalContent extends StatefulWidget {
  final ScrollController controller;
  final Function(String, String, ) onAddNote;

  const ModalContent({Key? key, required this.controller, required this.onAddNote}) : super(key: key);

  @override
  State<ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajouter un Note ✨',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 25, 25, 25),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Titre ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 3, 159, 1),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Titre de votre Note',
              ),
            ),
           
            const SizedBox(height: 8),
            const Text(
              'Details de cette Note ?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 3, 159, 1),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Détails dur la note',
              ),
            ),
            const SizedBox(height: 16),
         
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onAddNote(
                    _titleController.text.trim(),
                    _descriptionController.text.trim(),
                   
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 3, 159, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Nouvelle note',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

