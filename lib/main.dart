import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spinningwheel/Views/auth.dart';
import 'package:spinningwheel/SQLite/database_helper.dart'; // Importez le fichier contenant DatabaseHelper

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialisez la base de données avant de démarrer l'application
  await DatabaseHelper().initDB();

  // Obtenez le chemin de la base de données et affichez-le dans la console de débogage
  String dbPath = await DatabaseHelper.getDatabasePath();
  debugPrint('Chemin de la base de données : $dbPath');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roue de la fortune',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Notre première page
      home: const AuthScreen(),
    );
  }
}
