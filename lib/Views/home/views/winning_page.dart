import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/JSON/winnings.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';

class WinningPage extends StatefulWidget {
  final Users user;

  const WinningPage({Key? key, required this.user}) : super(key: key);

  @override
  _WinningPageState createState() => _WinningPageState();
}

class _WinningPageState extends State<WinningPage> {
  List<Winnings> winnings = [];

  @override
  void initState() {
    super.initState();
    fetchUserWinnings();
  }

  Future<void> fetchUserWinnings() async {
    final List<Winnings> userWinnings = await DatabaseHelper().getUserWinnings(widget.user.usrId!);
    setState(() {
      winnings = userWinnings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gains de ${widget.user.fullName ?? widget.user.usrName}'),
      ),
      body: winnings.isEmpty
          ? const Center(
              child: Text('Aucun gain disponible.'),
            )
          : ListView.builder(
              itemCount: winnings.length,
              itemBuilder: (context, index) {
                final Winnings winning = winnings[index];
                return ListTile(
                  title: Text('Montant: ${winning.amount}'),
                  subtitle: Text('Date: ${winning.date}\nDescription: ${winning.description}'),
                );
              },
            ),
    );
  }
}
