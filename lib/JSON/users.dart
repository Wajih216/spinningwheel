import 'dart:convert';

import 'package:spinningwheel/JSON/winnings.dart';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? usrId;
  final String? fullName;
  final String? email;
  final String usrName;
  final String password;
  final String phoneNumber;
  //final List<Winnings>? winnings; // Liste des gains de l'utilisateur

  Users({
    this.usrId,
    this.fullName,
    this.email,
    required this.usrName,
    required this.password,
    required this.phoneNumber,
    //this.winnings, // Ajout de winnings à la classe Users
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        fullName: json["fullName"],
        email: json["email"],
        usrName: json["usrName"],
        password: json["usrPassword"],
        phoneNumber: json["phoneNumber"],
       /* winnings: json["winnings"] != null
            ? List<Winnings>.from(json["winnings"].map((x) => Winnings.fromMap(x)))
            : null,*/
      );

  get id => usrId;

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "fullName": fullName,
        "email": email,
        "usrName": usrName,
        "usrPassword": password,
        "phoneNumber": phoneNumber,
        //"winnings": winnings != null ? List<dynamic>.from(winnings!.map((x) => x.toMap())) : null,
      };
}
