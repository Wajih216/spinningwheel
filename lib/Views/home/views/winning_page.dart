import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/JSON/winnings.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';

class WinningPage extends StatefulWidget {
  final Users user;

  const WinningPage({Key? key, required this.user}) : super(key: key);

  @override
  WinningPageState createState() => WinningPageState();
}

class WinningPageState extends State<WinningPage> {
  List<Winnings> winnings = [];

  @override
  void initState() {
    super.initState();
    fetchUserWinnings();
  }

  Future<void> fetchUserWinnings() async {
    final List<Winnings> userWinnings =
        await DatabaseHelper().getUserWinnings(widget.user.usrId!);
    setState(() {
      winnings = userWinnings.reversed.toList();
    });
  }

  void deleteAllUserWinnings() async {
    await DatabaseHelper().deleteAllUserWinnings(widget.user.usrId!);
    fetchUserWinnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Gains de ${widget.user.fullName ?? widget.user.usrName}'),
        automaticallyImplyLeading: false, // Enlever la flèche de retour
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(context),
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
                return ListTile(
                  title: Text('Montant: ${winning.item}'),
                  subtitle: Text(
                      'Date: ${winning.date}\nDescription: ${winning.description}'),
                );
              },
            ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const  Text('Confirmer la suppression'),
          content:const  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Êtes-vous sûr de vouloir supprimer tous les gains ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:const  Text('Supprimer'),
              onPressed: () {
                deleteAllUserWinnings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

