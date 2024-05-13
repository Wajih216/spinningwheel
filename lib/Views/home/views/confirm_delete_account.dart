import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';
import 'package:spinningwheel/Views/auth.dart';

class ConfirmDeleteAccountScreen extends StatelessWidget {
  final Users user;
  final DatabaseHelper _db = DatabaseHelper();

  ConfirmDeleteAccountScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmer la suppression'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Êtes-vous sûr de vouloir supprimer votre compte ?',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _deleteAccount(context);
              },
              child: const Text('Oui, supprimez mon compte.'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retour à l'écran précédent sans supprimer le compte
              },
              child: const Text('Non, revenir en arrière.'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    print("Deleting account...");
  
    var currentUser = user;
    print("id : ${currentUser.usrId}");
    print("Current User: $currentUser");

    // Ajoutez ici la logique de suppression du compte utilisateur
    final success = await _db.deleteUser(currentUser);
    if (success) {
      // Afficher une notification de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Naviguer vers l'écran d'authentification après la suppression du compte
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false, // supprime toutes les routes 
        );
    } else {
      // Afficher une notification d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete account'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
