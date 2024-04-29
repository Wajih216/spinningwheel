import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/winnings.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';

class WinningPage extends StatefulWidget {
  final int userId;

  const WinningPage({Key? key, required this.userId}) : super(key: key);

  @override
  _WinningPageState createState() => _WinningPageState();
}

class _WinningPageState extends State<WinningPage> {
  List<Winning> winnings = [];

  @override
  void initState() {
    super.initState();
    fetchUserWinnings();
  }

  Future<void> fetchUserWinnings() async {
    final List<Winning> userWinnings = await DatabaseHelper().getUserWinnings(widget.userId);
    setState(() {
      winnings = userWinnings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gains de l\'utilisateur'),
      ),
      body: ListView.builder(
        itemCount: winnings.length,
        itemBuilder: (context, index) {
          final Winning winning = winnings[index];
          return ListTile(
            title: Text('Montant: ${winning.amount}'),
            subtitle: Text('Date: ${winning.date}\nDescription: ${winning.description}'),
          );
        },
      ),
    );
  }
}
