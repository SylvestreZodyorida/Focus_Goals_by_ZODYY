

import 'package:fg_by_zodyy/pages/user/login_page.dart';
import 'package:fg_by_zodyy/pages/user/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl/intl.dart';

class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({super.key});

  @override
  _EmailSignUpPageState createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'FR'); // Default country FR

  Box? userBox;

  @override
  void initState() {
    super.initState();
    // Initialiser Hive
    Hive.initFlutter();
  }

  Future<void> _signUpWithEmail() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final birthDate = _birthDateController.text;
    final phone = _phoneController.text;

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        // Enregistrement des informations supplémentaires dans Firebase
        await user.updateProfile(displayName: name);
        await user.reload();

        // Enregistrer les données de l'utilisateur dans Hive
        var userBox = await Hive.openBox('userBox');
        await userBox.put('email', email);
        await userBox.put('name', name);
        await userBox.put('birthDate', birthDate);
        await userBox.put('phone', phone);

        // Mettre à jour l'état de connexion dans Hive
        await userBox.put('isLoggedIn', true);  // Mise à jour de isLoggedIn

        // Envoi de l'email de confirmation
        await user.sendEmailVerification();

        // Si l'inscription réussie, redirige vers la page de profil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } catch (e) {
      String errorMessage = 'Erreur d\'inscription';

      // Gestion des erreurs Firebase spécifiques
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Cet email est déjà utilisé.';
            break;
          case 'invalid-email':
            errorMessage = 'Email invalide.';
            break;
          case 'weak-password':
            errorMessage = 'Le mot de passe est trop faible. Utilisez un mot de passe plus fort.';
            break;
          case 'network-request-failed':
            errorMessage = 'Problème de connexion. Veuillez vérifier votre réseau.';
            break;
          default:
            errorMessage = 'Une erreur inconnue s\'est produite. Essayez à nouveau.';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      _birthDateController.text = dateFormat.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.sign_up)),
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 11, 3, 44), // Fond bleu
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.asset(
                      'assets/images/rounded_logo.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bloc arrondi avec fond blanc légèrement transparent
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.name,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _selectBirthDate(context),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _birthDateController,
                              decoration: InputDecoration(
                                labelText: appLocalizations.birth_date,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              _phoneNumber = number;
                            });
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                            showFlags: true,
                            setSelectorButtonAsPrefixIcon: true,
                          ),
                          initialValue: _phoneNumber,
                          textFieldController: _phoneController,
                          inputDecoration: InputDecoration(
                            labelText: appLocalizations.phone_number,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.email,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.password,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _signUpWithEmail,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            backgroundColor: const Color.fromARGB(255, 2, 10, 90),
                          ),
                          child: Text(
                            appLocalizations.signup,
                            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Ajout du texte "Déjà membre ?"
                  Center(
                    child: Text(
                      appLocalizations.already_a_member,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        appLocalizations.sign_in,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 255, 165, 69),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
