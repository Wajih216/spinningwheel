// database_helper.dart

import 'package:path/path.dart';
import 'package:spinningwheel/JSON/winnings.dart';
import 'package:sqflite/sqflite.dart';
import '../JSON/users.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  final String databaseName = "auth.db";

  // Tables
  String userTable = '''
    CREATE TABLE users (
      usrId INTEGER PRIMARY KEY AUTOINCREMENT,
      fullName TEXT,
      email TEXT,
      usrName TEXT UNIQUE,
      usrPassword TEXT, 
      phoneNumber TEXT UNIQUE
    )
  ''';


  String winningsTable = '''
    CREATE TABLE winnings (
      usrId INTEGER,
      item TEXT,
      date TEXT,
      description TEXT,
      FOREIGN KEY (usrId) REFERENCES users(usrId)
    )
  ''';

  // Our connection is ready
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, 
      version: 1,
      onCreate: (db, version) async {
      await db.execute(userTable);
      await db.execute(winningsTable);
    });
  }

  // Function methods

  // Authentication
  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' AND phoneNumber = '${usr.phoneNumber}' ");
    return result.isNotEmpty;
  }

  // Sign up
  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }

  // Get current User details
  Future<Users?> getUser(String usrName) async {
    final Database db = await initDB();
    var res = await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  // Add winning
  Future<void> addWinning(Winnings winning) async {
    final Database db = await initDB();
    await db.insert('winnings', winning.toMap());
  }

  // Get user winnings
  Future<List<Winnings>> getUserWinnings(int usrId) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'winnings',
      where: 'usrId = ?',
      whereArgs: [usrId],
    );

    return List.generate(maps.length, (i) {
      return Winnings.fromMap(maps[i]);
    });
  }

  // Supprimer un gain spécifique par son ID
  Future<void> deleteWinning(int winningId) async {
    final Database db = await initDB();
    await db.delete(
      'winnings',
      where: 'usrId = ?',
      whereArgs: [winningId],
    );
  }

  // Vider tous les gains d'un utilisateur
  Future<void> deleteAllUserWinnings(int userId) async {
    final Database db = await initDB();
    await db.delete(
      'winnings',
      where: 'usrId = ?',
      whereArgs: [userId],
    );
  } 

  static Future<String> getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


}
