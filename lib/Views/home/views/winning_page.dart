import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/JSON/winnings.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';class WinningPage extends StatefulWidget {
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

  void deleteWinning(int winningId) async {
    await DatabaseHelper().deleteWinning(winningId);
    fetchUserWinnings();
  }

  void deleteAllUserWinnings() async {
    await DatabaseHelper().deleteAllUserWinnings(widget.user.usrId!);
    fetchUserWinnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gains de ${widget.user.fullName ?? widget.user.usrName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => deleteAllUserWinnings(),
          ),
        ],
      ),
      body: winnings.isEmpty
          ? const Center(
              child: Text('Aucun gain disponible.'),
            )
          : ListView.builder(
              itemCount: winnings.length,
              itemBuilder: (context, index) {
                final Winnings winning = winnings[index];
                return Dismissible(
                  key: Key(winning.usrId.toString()),
                  onDismissed: (_) => deleteWinning(winning.usrId),
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text('Montant: ${winning.item}'),
                    subtitle: Text('Date: ${winning.date}\nDescription: ${winning.description}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteWinning(winning.usrId),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
