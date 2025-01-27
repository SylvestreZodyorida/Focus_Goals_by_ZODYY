

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fg_by_zodyy/pages/custom_app_bar.dart';
import 'package:fg_by_zodyy/pages/custom_bottom_bar.dart';
import 'package:intl/intl.dart';

class ObjectifsPage extends StatefulWidget {
  const ObjectifsPage({Key? key}) : super(key: key);

  @override
  State<ObjectifsPage> createState() => _ObjectifsPageState();
}

class _ObjectifsPageState extends State<ObjectifsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _addObjective(String title, String description, DateTime? startDate, DateTime? endDate) async {
    if (user == null || title.isEmpty || description.isEmpty || startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs correctement.')),
      );
      return;
    }

    if (endDate.isBefore(startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La date de fin doit être postérieure à la date de début.')),
      );
      return;
    }

    final objectivesCollection = firestore.collection('objectives');
    await objectivesCollection.add({
      'userId': user!.uid,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context); // Fermer le modal après ajout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Objectif ajouté avec succès.')),
    );
  }

  Future<void> _openModalAdd(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return ModalContent(controller: controller, onAddObjective: _addObjective);
          },
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
        backgroundColor: const Color.fromARGB(255, 255, 136, 0),
        child: const Icon(Icons.add_task_sharp, color: Color.fromARGB(255, 248, 248, 248)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Stack(
        
        children: [
          Positioned(
      top: 0, // Ajustez la position verticale selon vos besoins
      left: 16,
      child: const Text(
        'Vos objectifs ✨',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 25, 25, 25),
        ),
      ),
    ),
            
          // StreamBuilder pour afficher les objectifs
          StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('objectives')
                  .where('userId', isEqualTo: user?.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur de chargement des objectifs: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun objectif trouvé. Ajoutez-en un nouveau ✨',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                

                final objectives = snapshot.data!.docs;
                print(objectives); // Voir les données récupérées

                return ListView.builder(
                  itemCount: objectives.length,
                  itemBuilder: (context, index) {
                    final data = objectives[index].data() as Map<String, dynamic>;
                    print(data); // Voir les données de chaque objectif
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(data['title'] ?? 'Sans titre'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data['description'] != null)
                              Text(data['description'], style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            if (data['startDate'] != null)
                              Text(
                                'Début: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['startDate']))}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            if (data['endDate'] != null)
                              Text(
                                'Fin: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['endDate']))}',
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await objectives[index].reference.delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),


          // Bouton flottant personnalisé
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                _openModalAdd(context);
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3), // décalage ombre
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),

    );
  }
}

class ModalContent extends StatefulWidget {
  final ScrollController controller;
  final Function(String, String, DateTime?, DateTime?) onAddObjective;

  const ModalContent({Key? key, required this.controller, required this.onAddObjective}) : super(key: key);

  @override
  State<ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

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
              'Ajouter un objectif ✨',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 25, 25, 25),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Votre objectif ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
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
                hintText: 'Décrivez votre objectif',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quand ?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Début', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _startDate != null
                                ? DateFormat('dd/MM/yyyy').format(_startDate!)
                                : 'JJ/MM/AAAA',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fin', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _endDate != null
                                ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                : 'JJ/MM/AAAA',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Pourquoi cet objectif ?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
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
                hintText: 'Expliquez pourquoi cet objectif est important',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Comment l’atteindre ?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Décrivez les étapes pour atteindre cet objectif',
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onAddObjective(
                    _titleController.text.trim(),
                    _descriptionController.text.trim(),
                    _startDate,
                    _endDate,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Ajouter',
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

