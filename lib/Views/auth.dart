import 'package:flutter/material.dart';
import 'package:spinningwheel/Components/button.dart';
import 'package:spinningwheel/Components/colors.dart';
import 'package:spinningwheel/Views/login.dart';
import 'package:spinningwheel/Views/signup.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Authentification",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const Text(
                "Authentifiez-vous pour accéder au jeu",
                style: TextStyle(color: Colors.grey),
              ),
              Expanded(child: Image.asset("assets/telecom.jpg")),
              Button(label: "SE CONNECTER", press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
              }),
              Button(label: "S'INSCRIRE", press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
              }),
            ],
          ),
        ),
      )),
    );
  }
}
