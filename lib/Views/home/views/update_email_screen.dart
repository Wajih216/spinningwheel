import 'package:flutter/material.dart';

class UpdateEmailScreen extends StatelessWidget {
  const UpdateEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Your Email',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Current Email',
                hintText: 'Enter your current email',
              ),
              keyboardType: TextInputType.emailAddress,
              // Ajoutez la logique de validation si nécessaire
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'New Email',
                hintText: 'Enter your new email',
              ),
              keyboardType: TextInputType.emailAddress,
              // Ajoutez la logique de validation si nécessaire
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm New Email',
                hintText: 'Confirm your new email',
              ),
              keyboardType: TextInputType.emailAddress,
              // Ajoutez la logique de validation si nécessaire
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Ajoutez la logique pour mettre à jour l'e-mail
              },
              child: const Text('Update Email'),
            ),
          ],
        ),
      ),
    );
  }
}
