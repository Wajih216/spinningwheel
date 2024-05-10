// signup_screen.dart

import 'package:flutter/material.dart';
import 'package:spinningwheel/Components/button.dart';
import 'package:spinningwheel/Components/colors.dart';
import 'package:spinningwheel/Components/textfield.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/Views/login.dart';

import '../SQLite/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  // Controllers
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final db = DatabaseHelper();

  void signUp() async {
    // Check if user inputs are not empty
    if (fullName.text.isEmpty ||
        email.text.isEmpty ||
        usrName.text.isEmpty ||
        password.text.isEmpty ||
        phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Check phone number format
    if (!RegExp(r'^9[0-9]{1}$').hasMatch(phoneNumber.text.substring(0, 2))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number must start with "90" to "99"')),
      );
      return;
    }

    // Check phone number length
    if (phoneNumber.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number must be 8 digits long')),
      );
      return;
    }

    // Check for repeating digits in phone number
    if (RegExp(r'(\d)\1\1\1').hasMatch(phoneNumber.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number cannot contain a series of the same digit')),
      );
      return;
    }

    // Check password format
    if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}\[\]:;<>,./?\\|`~\-]).{8,}$')
        .hasMatch(password.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character, and be at least 8 characters long')),
      );
      return;
    }

    // Check email format
    String? emailValidationMessage = validateEmail(email.text);
    if (emailValidationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailValidationMessage)),
      );
      return;
    }

    // Check if user with same username, email, or phone number already exists
    bool userExists = await db.checkDuplicateUser(usrName.text, email.text, phoneNumber.text);
    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An account with the same username, email, or phone number already exists')),
      );
      return;
    }

    // Proceed with signup
    var res = await db.createUser(Users(
        fullName: fullName.text,
        email: email.text,
        usrName: usrName.text,
        password: password.text,
        phoneNumber: phoneNumber.text));
    if (res > 0) {
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Register New Account",
                    style: TextStyle(color: primaryColor, fontSize: 55, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                InputField(hint: "Full name", icon: Icons.person, controller: fullName),
                InputField(hint: "Email", icon: Icons.email, controller: email),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password, passwordInvisible: true),
                InputField(hint: "Phone Number", icon: Icons.phone, controller: phoneNumber),
                const SizedBox(height: 10),
                Button(label: "SIGN UP", press: signUp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Text("LOGIN"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
