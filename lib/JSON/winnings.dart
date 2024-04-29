
import 'dart:convert';

Winnings usersFromMap(String str) => Winnings.fromMap(json.decode(str));

String usersToMap(Winnings data) => json.encode(data.toMap());

class Winnings {
  final int usrId;
  final double amount;  
  final String date;
  final String description;

  Winnings({
    required this.usrId,
    required this.amount,
    required this.date,
    required this.description,
  });

  //These json value must be same as your column name in database that we have already defined
  //one column didn't match
  factory Winnings.fromMap(Map<String, dynamic> json) => Winnings(
    usrId: json["usrId"],
    amount: json["amount"],
    date: json["date"],
    description: json["description"],
  );

  get id => null;

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "amount": amount,   
    "date": date,
    "description": description,
  };
}
