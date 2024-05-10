import 'package:flutter/material.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/JSON/winnings.dart';
import 'package:spinningwheel/Views/auth.dart';
import 'package:spinningwheel/Views/home/views/about_view.dart';
import 'package:spinningwheel/Views/home/views/account_settings_view.dart';
import 'package:spinningwheel/Views/home/views/game_view.dart';
import 'package:spinningwheel/Views/home/views/winning_page.dart';
import 'package:spinningwheel/Views/profile.dart';
import 'package:spinningwheel/Views/home/views/settings_view.dart';

class HomeScreen extends StatefulWidget {
  
  final Users user ; 
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);  
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title:const Text('Spinning Wheel'),
        backgroundColor: Colors.blue,
        leading : Builder(
          builder : (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Icône de menu
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Ouvrir la barre de navigation latérale
              },
            );
          }, 
        ),  
      ),
      drawer: Drawer(
        // Barre de navigation latérale
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
           DrawerHeader(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 50, // Ajustez la hauteur au besoin
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Ajustez les marges intérieures au besoin
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20, // Ajustez la taille de la police au besoin
                    color: Colors.white, // Couleur du texte
                  ),
                ),
              ),
            ),
          ),
            ListTile(
              leading: const Icon(Icons.account_circle), // Icône Paramètres de compte
              title: const Text('Account Settings'),
              onTap: () {
                // Gérer le tap sur l'élément Paramètres de compte
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettingsScreen(user : widget.user)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings), // Icône Paramètres
              title: const  Text('Settings'),
              onTap: () {
                // Gérer le tap sur l'élément Paramètres
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const  Icon(Icons.info), // Icône "À propos"
              title: const  Text('About'),
              onTap: () {
                // Gérer le tap sur l'élément "À propos"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout), // Icône de déconnexion
              title: const  Text('Log out'), // Titre du ListTile
              onTap: () {
                // Gérer le tap sur l'élément de déconnexion
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AuthScreen()));           // Fermer la barre de navigation latérale
              },
            ),
            // Ajoutez d'autres éléments de navigation selon vos besoins
          ],
        ),
      ), 
      body: PageView(
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        controller: _pageController,
        children: <Widget>[
          GameView(user : widget.user,),
          WinningPage(user : widget.user),
          Profile(profile : widget.user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad_sharp),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Prizes List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}