// winning.dart

class Winning {
  final int id;
  final int userId;
  final double amount;
  final String date;
  final String description;

  Winning({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory Winning.fromMap(Map<String, dynamic> json) => Winning(
        id: json['id'],
        userId: json['userId'],
        amount: json['amount'],
        date: json['date'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'amount': amount,
        'date': date,
        'description': description,
      };
}
