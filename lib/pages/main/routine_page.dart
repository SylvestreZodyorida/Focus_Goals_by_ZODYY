import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fg_by_zodyy/pages/custom_app_bar.dart';
import 'package:fg_by_zodyy/pages/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({Key? key}) : super(key: key);

  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  final TextEditingController _routineController = TextEditingController();
  TimeOfDay? _selectedTime;

  final List<Map<String, dynamic>> _defaultRoutines = [
    {'text': 'Ajoutez les éléments de votre routine journalière ici 💪', 'time': "00:00 (l'heure)", 'done': false},
  ];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  // Fonction pour ajouter une nouvelle routine
  Future<void> _addRoutine() async {
    if (_routineController.text.isEmpty || _selectedTime == null) return;

    final String formattedTime =
        "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('routines')
        .add({
      'text': _routineController.text,
      'done': false,
      'time': formattedTime,
      'createdAt': FieldValue.serverTimestamp(),
      'lastReset': FieldValue.serverTimestamp(), // Ajout du champ lastReset
    });

    _routineController.clear();
    setState(() {
      _selectedTime = null;
    });

    Navigator.of(context).pop();
  }

  // Fonction pour basculer l'état de la routine (terminée/non terminée)
  Future<void> _toggleRoutine(String routineId, bool currentState) async {
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('routines')
        .doc(routineId)
        .update({'done': !currentState});
  }

  // Fonction pour supprimer une routine
  Future<void> _deleteRoutine(String routineId) async {
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('routines')
        .doc(routineId)
        .delete();
  }

  // Fonction pour ouvrir la modal d'ajout de routine
  void _openAddRoutineModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ajouter une routine journalière',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _routineController,
                  decoration: const InputDecoration(
                    labelText: "Nom de la routine",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text(_selectedTime == null
                      ? "Choisir une heure"
                      : "Heure sélectionnée : ${_selectedTime!.format(context)}"),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _addRoutine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 45, 1, 52),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  ),
                  child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fonction pour vérifier et réinitialiser les routines chaque jour
  void _resetRoutinesAtMidnight() async {
    final currentDate = DateTime.now();

    final snapshot = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('routines')
        .get();

    for (var doc in snapshot.docs) {
      final routineData = doc.data();
      final lastResetTimestamp = routineData['lastReset'];

      if (lastResetTimestamp == null) {
        // Si lastReset est null, on l'initialise à la date actuelle
        await _firestore
            .collection('users')
            .doc(_user!.uid)
            .collection('routines')
            .doc(doc.id)
            .update({
          'done': false,
          'lastReset': FieldValue.serverTimestamp(), // Initialisation de la date de réinitialisation
        });
      } else {
        final lastReset = (lastResetTimestamp as Timestamp).toDate();

        if (lastReset.day != currentDate.day) {
          // Réinitialiser la routine si elle a été réinitialisée avant aujourd'hui
          await _firestore
              .collection('users')
              .doc(_user!.uid)
              .collection('routines')
              .doc(doc.id)
              .update({
            'done': false,
            'lastReset': FieldValue.serverTimestamp(), // Mise à jour de la date de réinitialisation
          });
        }
      }
    }
  }

  // Fonction pour réinitialiser toutes les routines
  Future<void> _resetAllRoutines() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('routines')
        .get();

    for (var doc in snapshot.docs) {
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('routines')
          .doc(doc.id)
          .update({'done': false});
    }
  }

  // Fonction de déconnexion
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Fonction pour trier les routines par heure
  List<Map<String, dynamic>> _sortRoutinesByTime(List<Map<String, dynamic>> routines) {
    routines.sort((a, b) {
      final timeA = _parseTime(a['time']);
      final timeB = _parseTime(b['time']);
      return timeA.compareTo(timeB);
    });
    return routines;
  }

  // Fonction pour convertir une heure au format "HH:mm" en TimeOfDay
  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1].split(' ')[0]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    // Appel de la fonction pour réinitialiser les routines à minuit
    _resetRoutinesAtMidnight();

    return Scaffold(
      appBar: CustomAppBar(
        user: _user,
        userName: _user?.displayName,
        userImageUrl: _user?.photoURL,
        onLogout: () => _logout(context),
      ),
      bottomNavigationBar: CustomBottomBar(openModal: _openAddRoutineModal),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddRoutineModal,
        backgroundColor: const Color.fromARGB(255, 45, 1, 52),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 20, 24, 82), const Color.fromARGB(134, 2, 28, 70)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texte pour les routines journalières
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Routines journalières',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  // Bouton de réinitialisation des routines
                  ElevatedButton(
                    onPressed: _resetAllRoutines,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fond rouge
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Réinitialiser'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Liste des routines
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(_user!.uid)
                      .collection('routines')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Map<String, dynamic>> routines = List.from(_defaultRoutines);

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      for (var doc in snapshot.data!.docs) {
                        final routineData = doc.data() as Map<String, dynamic>;
                        routines.add({
                          'text': routineData['text'],
                          'time': routineData['time'],
                          'done': routineData['done'],
                          'id': doc.id,
                        });
                      }
                    }

                    routines = _sortRoutinesByTime(routines);

                    return ListView.builder(
                      itemCount: routines.length,
                      itemBuilder: (context, index) {
                        final routine = routines[index];
                        final bool isCustomRoutine = routine.containsKey('id');

                        return Card(
                          elevation: 3,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: Checkbox(
                              value: routine['done'],
                              onChanged: isCustomRoutine
                                  ? (value) => _toggleRoutine(routine['id'], routine['done'])
                                  : null,
                              activeColor: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            title: Text(
                              routine['text'],
                              style: TextStyle(
                                fontSize: 18,
                                decoration: routine['done'] ? TextDecoration.lineThrough : null,
                                color: routine['done'] ? const Color.fromARGB(255, 250, 158, 135) : const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            subtitle: Text(
                              "🕒 ${routine['time']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: isCustomRoutine
                                ? IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteRoutine(routine['id']),
                                  )
                                : null,
                          ),
                        );
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
