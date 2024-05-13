import 'package:flutter/material.dart';
import 'package:spinningwheel/Components/button.dart';
import 'package:spinningwheel/Components/colors.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/Views/auth.dart';


class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({Key? key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 77,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/no_user.jpg"),
                    radius: 75,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile!.fullName ?? "",
                  style: const TextStyle(fontSize: 28, color: primaryColor),
                ),
                Text(
                  profile!.email ?? "",
                  style: const TextStyle(fontSize: 17, color: Colors.grey),
                ),
                ListTile(
                  leading: const Icon(Icons.person, size: 30),
                  subtitle: const Text("Nom complet"),
                  title: Text(profile!.fullName ?? ""),
                ),
                ListTile(
                  leading: const Icon(Icons.email, size: 30),
                  subtitle: const Text("Email"),
                  title: Text(profile!.email ?? ""),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle, size: 30),
                  subtitle: const Text("Pseudo"),
                  title: Text(profile!.usrName),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, size: 30),
                  subtitle: const Text("Numéro de téléphone"),
                  title: Text(profile!.phoneNumber),
                ),
                Button(
                  label: "SE DECONNECTER",
                  press: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                      (route) => false, // supprime toutes les routes 
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
