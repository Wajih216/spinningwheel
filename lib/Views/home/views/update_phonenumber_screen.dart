import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';

import '../../login.dart';

class ChangePhoneNumberScreen extends StatefulWidget {
  final Users user;

  const ChangePhoneNumberScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePhoneNumberScreen> createState() => ChangePhoneNumberScreenState();
}

class ChangePhoneNumberScreenState extends State<ChangePhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPhoneNumberController = TextEditingController();
  final _newPhoneNumberController = TextEditingController();
  final _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer le numéro de téléphone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Changer votre numéro de téléphone',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _currentPhoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de téléphone actuel',
                  hintText: 'Entrez votre numéro de téléphone actuel',
                ),
                keyboardType: TextInputType.phone,
                // Ajoutez la logique de validation si nécessaire
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _newPhoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Nouveau numéro de téléphone',
                  hintText: 'Entrez votre nouveau numéro de téléphone',
                ),
                keyboardType: TextInputType.phone,
                // Ajoutez la logique de validation si nécessaire
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePhoneNumber(context);
                  }
                },
                child: const Text('Changer de numéro de téléphone'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePhoneNumber(BuildContext context) async {
    print("Changement de numéro de téléphone !");
    print("Numéro de téléphone actuel : ${_currentPhoneNumberController.text}");
    print("Nouveau numéro de téléphone : ${_newPhoneNumberController.text}");
    
    var currentUser = widget.user;
    print("id : ${currentUser.usrId}") ; 
    print("Utilisateur actuel : $currentUser");

    // Vérifiez le numéro de téléphone actuel
    if (currentUser.phoneNumber != _currentPhoneNumberController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mauvais numéro de téléphone !'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else {
      // Vérifiez si le nouveau numéro de téléphone respecte le format, la longueur et le motif requis
      String newPhoneNumber = _newPhoneNumberController.text;
      
      // Vérifiez la longueur du numéro de téléphone (doit comporter au moins 8 chiffres)
      if (newPhoneNumber.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le numéro de téléphone doit comporter au moins 8 chiffres')),
        );
        return;
      }

      // Vérifiez le format du numéro de téléphone (doit commencer par "90" à "99")
      if (!RegExp(r'^9[0-9]{1}').hasMatch(newPhoneNumber.substring(0, 2))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le numéro de téléphone doit commencer par "90" à "99"')),
        );
        return;
      }

      // Vérifiez s'il existe des chiffres répétés dans le numéro de téléphone
      if (RegExp(r'(\d)\1\1\1').hasMatch(newPhoneNumber)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le numéro de téléphone ne peut pas contenir une série de chiffres identiques')),
        );
        return;
      }

      // Mettre à jour le numéro de téléphone
      final updatedUser = Users(
        usrId: currentUser.usrId,
        fullName: currentUser.fullName,
        email: currentUser.email,
        usrName: currentUser.usrName,
        password: currentUser.password,
        phoneNumber: newPhoneNumber,
      );

      final success = await _db.updateUser(updatedUser);
      if (success) {
        // Afficher une notification de réussite
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Numéro de téléphone mis à jour avec succès'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // supprime toutes les routes 
        );
      } else {
        // Afficher une notification d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de la mise à jour du numéro de téléphone'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
