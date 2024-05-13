import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/Views/home/views/change_password_screen.dart';
import 'package:spinningwheel/Views/home/views/confirm_delete_account.dart';
import 'package:spinningwheel/Views/home/views/update_email_screen.dart';
import 'package:spinningwheel/Views/home/views/update_phonenumber_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  final Users user;
  const AccountSettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paramètres du compte',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Changer le mot de passe'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen(user: user)));
              },
            ),
            ListTile(
              title: const Text('Changer l\'adresse e-mail'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEmailScreen(user : user)));
              },
            ),
             ListTile(
              title: const Text('Changer le numéro de téléphone'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePhoneNumberScreen(user : user)));
              },
            ),
            ListTile(
              title: const Text('Supprimer le compte'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute( builder : (context) => ConfirmDeleteAccountScreen(user: user))) ;
              },
            )
          ],
        ),
      ),
    );
  }
}


