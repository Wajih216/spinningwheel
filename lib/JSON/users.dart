import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? usrId; // Modifiez le type de données ici
  final String? fullName;
  final String? email;
  final String usrName;
  final String password;
  final String phoneNumber;
  
  Users({
    required this.usrId, // Modifiez ici également
    this.fullName,
    this.email,
    required this.usrName,
    required this.password,
    required this.phoneNumber,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        fullName: json["fullName"],
        email: json["email"],
        usrName: json["usrName"],
        password: json["usrPassword"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId, 
        "fullName": fullName,
        "email": email,
        "usrName": usrName,
        "usrPassword": password,
        "phoneNumber": phoneNumber,
      };

  get id => usrId;
  
}
