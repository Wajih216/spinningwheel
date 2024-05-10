import 'dart:convert';

Winnings winningsFromMap(String str) => Winnings.fromMap(json.decode(str));

String winningsToMap(Winnings data) => json.encode(data.toMap());

class Winnings {
  final int usrId;
  final String item;  
  final String date;
  final String description;

  Winnings({
    required this.usrId,
    required this.item,
    required this.date,
    required this.description,
  });

  factory Winnings.fromMap(Map<String, dynamic> json) => Winnings(
    usrId: json["usrId"],
    item: json["item"],
    date: json["date"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "item": item,   
    "date": date,
    "description": description,
  };
}
