import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameState();
}

class _GameState extends State<GameView> with SingleTickerProviderStateMixin {
  
  List<double> sectors = [1, 2, 3, 4, 5, 6, 7, 8, 9 ,10];
  int randomSectorIndex = -1; 
  List<double> sectorRadians = [];
  double angle = 0;

  bool spinning = false;
  double earnedValue = 0;
  double totalEarnings = 0; 
  int spins = 0;

  math.Random random = math.Random();
  
  late AnimationController controller;
  late Animation<double> animation;
  @override 
  void initState() {
    super.initState();
    generateSectorRadians();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    Tween<double> tween = Tween(begin: 0, end: 1);  
    CurvedAnimation curve = CurvedAnimation(
      parent: controller, 
      curve: Curves.decelerate,
    );
    animation = tween.animate(curve); 
    controller.addListener(() { 
      if (controller.isCompleted) {
        setState(() {
          recordStats(); 
          spinning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromARGB(255, 35, 153, 207),
      child: _gameContent(), 
    ); 
  }

  Widget _gameContent() {
    return Stack(
      children: [
        _title(),
        _wheel(),
        //_spinButton(),
        //_gameActions(),
        //_gameStats(),
      ],
    );
  }

  Widget _title() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: CupertinoColors.systemYellow,
            width: 2, 
          ), 
          gradient: const LinearGradient(
            colors: [
              Color(0XFF2d014c), 
              Color(0XFFf8009e),
            ],
            begin: Alignment.bottomLeft, 
            end: Alignment.topRight,
          ),
        ), 
        child: const Text(
          'Spinning Wheel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ); 
  }

  Widget _wheel() {
    return Center(
      child : Container(
        padding : const EdgeInsets.only(top: 20, left:5),
        width : MediaQuery.of(context).size.width * 0.9,
        height : MediaQuery.of(context).size.width * 0.5, 
        decoration : const BoxDecoration(
          image : DecorationImage(
            image : AssetImage('assets/images/belt.png'),
            fit : BoxFit.contain,
          )   
        ),
        //use animated builder for spinning 
        child : InkWell(
          child : AnimatedBuilder(
            animation: animation, 
            builder: (context ,child){
              return Transform.rotate(
                angle: controller.value * angle,
                child: Container(
                  margin : EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
                  decoration : const BoxDecoration(
                    image : DecorationImage(
                      image : AssetImage('assets/images/wheel.png'),
                      fit : BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ), 
          onTap : () {
            // if not spinning, then spin the wheel
            setState((){
              if(!spinning){
                // spin() ; // method to spin the wheel
              }
            
            }) ; 
          }

        ), 
    ),
    );
  }

  void generateSectorRadians() {
    double sectorAngle = 2 * math.pi / sectors.length;
    for (int i = 0; i < sectors.length; i++) {
      sectorRadians.add(sectorAngle * i);
    }
  }

  //used to record game statistics
  void recordStats() {
    earnedValue = sectors[sectors.length - (randomSectorIndex + 1)];
    totalEarnings += earnedValue; 
    spins += 1; 
  }
}
