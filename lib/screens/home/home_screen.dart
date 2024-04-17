import 'package:flutter/material.dart';
import 'package:spinningwheel/screens/home/views/game_view.dart';
import 'package:spinningwheel/screens/home/views/list_prizes_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        title: const Text('Spinning Wheel'),
      ),
      body: PageView(
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        controller: _pageController,
        children: const <Widget>[
          GameView(),
          ListPrizesView(),
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
            icon: Icon(Icons.home),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Prizes List',
          ),
          
        ],
      ),
    );
  }
}