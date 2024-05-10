import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';

import '../../login.dart';

class ChangePasswordScreen extends StatelessWidget {
  final Users user;
  const ChangePasswordScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: const ChangePasswordForm(),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Your Password',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your new password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _confirmNewPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                hintText: 'Confirm your new password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _changePassword();
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    print("Changing password ! ") ; 
    print("Current Password: ${_currentPasswordController.text}");
    print("New Password: ${_newPasswordController.text}");
    print("Confirm New Password: ${_confirmNewPasswordController.text}");
    final currentUser = await _db.getUser("current_user");
    if (currentUser == null) {
      print("Error: User not found!");
      return;
    }
    print("Current User: $currentUser");
    // Verify the current password
    if (currentUser.password != _currentPasswordController.text) {
      // Handle error: current password is incorrect
      return;
    }else {

    // Update the password
    final updatedUser = Users(
      fullName: currentUser.fullName,
      email: currentUser.email,
      usrName: currentUser.usrName,
      password: _newPasswordController.text,
      phoneNumber: currentUser.phoneNumber,
    );

    final success = await _db.updateUser(updatedUser);
    if (success) {
      // Afficher une notification de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('Password updated successfully'),
          duration:  Duration(seconds: 2),
        ),
      );
      
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    } else {
      // Afficher une notification d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('Failed to update password'),
          duration:  Duration(seconds: 2),
        ),
      );
    }
    }

  }
}
