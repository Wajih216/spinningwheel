import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';

import '../../login.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Users user;

  const ChangePasswordScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer le mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Changer votre mot de passe',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe actuel',
                  hintText: 'Entrez votre mot de passe actuel',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe actuel';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  hintText: 'Entrez votre nouveau mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nouveau mot de passe';
                  }
                  // Vérifiez le format du mot de passe
                  if (!RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}\[\]:;<>,./?\\|`~\-]).{8,}$')
                      .hasMatch(value)) {
                    return 'Le mot de passe doit contenir au moins une lettre majuscule, une lettre minuscule, un chiffre, un caractère spécial et doit comporter au moins 8 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _confirmNewPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le nouveau mot de passe',
                  hintText: 'Confirmez votre nouveau mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre nouveau mot de passe';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePassword(context);
                  }
                },
                child: const Text('Changer de mot de passe'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    print("Changement de mot de passe !");
    print("Mot de passe actuel : ${_currentPasswordController.text}");
    print("Nouveau mot de passe : ${_newPasswordController.text}");
    print("Confirmer le nouveau mot de passe : ${_confirmNewPasswordController.text}");
    
    var currentUser = widget.user;
    print("id : ${currentUser.usrId}") ; 
    print("Utilisateur actuel : $currentUser");

    // Vérifiez le mot de passe actuel
    if (currentUser.password != _currentPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mauvais mot de passe !'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else {
      // Mettre à jour le mot de passe
      final updatedUser = Users(
        usrId: currentUser.usrId,
        fullName: currentUser.fullName,
        email: currentUser.email,
        usrName: currentUser.usrName,
        password: _newPasswordController.text,
        phoneNumber: currentUser.phoneNumber,
      );

      final success = await _db.updateUser(updatedUser);
      if (success) {
        // Afficher une notification de réussite
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mot de passe mis à jour avec succès'),
            duration: Duration(seconds: 2),
          ),
        );

        // Naviguer vers l'écran de connexion après la mise à jour du mot de passe
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // supprime toutes les routes 
        );
      } else {
        // Afficher une notification d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de la mise à jour du mot de passe'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
