import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';

import '../../login.dart';

class UpdateEmailScreen extends StatefulWidget {
  final Users user;

  const UpdateEmailScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateEmailScreen> createState() => UpdateEmailScreenState();
}

class UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentEmailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _confirmNewEmailController = TextEditingController();
  final _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer l\'email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Changer votre email',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _currentEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email actuel',
                  hintText: 'Entrez votre email actuel',
                ),
                keyboardType: TextInputType.emailAddress,
                // Ajoutez une logique de validation si nécessaire
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _newEmailController,
                decoration: const InputDecoration(
                  labelText: 'Nouvel email',
                  hintText: 'Entrez votre nouvel email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nouvel email';
                  }
                  // Vérifiez si le nouvel email est valide
                  if (!isValidEmail(value)) {
                    return 'Veuillez entrer une adresse email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _confirmNewEmailController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le nouvel email',
                  hintText: 'Confirmez votre nouvel email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre nouvel email';
                  }
                  if (value != _newEmailController.text) {
                    return 'Les emails ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changeEmail(context);
                  }
                },
                child: const Text('Changer l\'email'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeEmail(BuildContext context) async {
    print("Changement d'email ! ");
    print("Email actuel : ${_currentEmailController.text}");
    print("Nouvel email : ${_newEmailController.text}");
    print("Confirmer le nouvel email : ${_confirmNewEmailController.text}");
    
    var currentUser = widget.user;
    print("id : ${currentUser.usrId}") ; 
    print("Utilisateur actuel : $currentUser");

    // Vérifiez l'email actuel
    if (currentUser.email != _currentEmailController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mauvais email !'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else {
      // Mettre à jour l'email
      final updatedUser = Users(
        usrId: currentUser.usrId,
        fullName: currentUser.fullName,
        email: _newEmailController.text,
        usrName: currentUser.usrName,
        password: currentUser.password,
        phoneNumber: currentUser.phoneNumber,
      );

      final success = await _db.updateUser(updatedUser);
      if (success) {
        // Afficher une notification de réussite
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email mis à jour avec succès'),
            duration: Duration(seconds: 2),
          ),
        );

        // Naviguer vers l'écran de connexion après la mise à jour de l'email
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // supprime toutes les routes 
        );
      } else {
        // Afficher une notification d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de la mise à jour de l\'email'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  bool isValidEmail(String email) {
    // Validation simple de l'email en utilisant une expression régulière
    return RegExp(
            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email);
  }
}
