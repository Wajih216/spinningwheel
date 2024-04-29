import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameState();
}

class _GameState extends State<GameView> with SingleTickerProviderStateMixin {
  
  List<double> sectors = [100, 20, 0.15, 0.5, 50, 20, 100, 50, 20, 50];
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

  //initializing the state
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
          spinning = false;
          recordStats(); // Mettre à jour les statistiques après l'arrêt de la roue
        });
      }
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.blue,
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
        _gameActions(),
        _gameStats(),
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
        padding : const EdgeInsets.only(top: 16, left:2),
        width : MediaQuery.of(context).size.width * 0.9,
        height : MediaQuery.of(context).size.width * 0.6, 
        decoration : const BoxDecoration(
          image : DecorationImage(
            image : AssetImage('assets/belt.png'),
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
                      image : AssetImage('assets/wheel.png'),
                      fit : BoxFit.contain,
                    )
                  ),
                ),
              );
            },
          ), 
          onTap : () {
            // if not spinning, then spin the wheel
            setState((){
              if(!spinning){
                spin() ; // method to spin the wheel
                spinning = true ; 
              }
            }) ; 
          }

        ), 
    ),
    );
  }

  void spin() {
    randomSectorIndex = random.nextInt(sectors.length);
    double randomRadian = generateRandomRadianToSpinTo() ; 
    controller.reset() ; 
    angle = randomRadian ;
    controller.forward() ;
  }

  double generateRandomRadianToSpinTo() {
    // make it spin at least 3 times
    return sectorRadians[randomSectorIndex] + (2 * math.pi * sectors.length) ;
  }

  void generateSectorRadians() {
    double sectorAngle = 2 * math.pi / sectors.length;
    for (int i = 0; i < sectors.length; i++) {
      sectorRadians.add(sectorAngle * (i+1));
    }
  }

  //used to record game statistics
  void recordStats() {
    earnedValue = sectors[sectors.length - randomSectorIndex - 1];
    totalEarnings += earnedValue; 
    spins += 1; 
  }
  //game stats
  Widget _gameStats() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left :20 , right: 20 ),
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
        child: Table(
          border : TableBorder.all(color: CupertinoColors.systemYellow),
          children : [
            TableRow(
              children : [
                _titleColumn("Earned") , 
                _titleColumn("Earnings") , 
                _titleColumn("Spins") ,
              ]
            ),
            TableRow(
              children : [
                _valueColumn(earnedValue) , 
                _valueColumn(totalEarnings) , 
                _valueColumn(spins) ,
              ]
            ),
          ],
        ), 
      ),
    );
  }

  Column _titleColumn(String title) {
    return Column(
      children : [
        Padding(
          padding : const EdgeInsets.symmetric(vertical : 5),
          child : Text(
            title,
            style : const TextStyle(
              color : Colors.white,
              fontSize : 20,
              fontWeight : FontWeight.bold,
            ),
          ),
        ), 
      ],
    );
  }

  Column _valueColumn(var value) {
     return Column(
      children : [
        Padding(
          padding : const EdgeInsets.symmetric(vertical : 5),
          child : Text(
            '$value',
            style : const TextStyle(
              color : Colors.white,
              fontSize : 20,
              fontWeight : FontWeight.bold,
            ),
          ),
        ), 
      ],
    );
  }

  Widget _gameActions() {
    return Align(
      alignment : Alignment.bottomRight, 
      child : Container(
        margin : EdgeInsets.only(bottom : MediaQuery.of(context).size.height * 0.17 , left : 20 , right : 20),
        child : Row(
          mainAxisAlignment : MainAxisAlignment.end,
          children : [
            InkWell(
              child : Container(
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
                padding : const EdgeInsets.symmetric(horizontal : 6 , vertical : 2),
                child : IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print("Withdraw \$$totalEarnings ");
                      resetGame() ; 
                    }
                  },
                  icon : const Icon(Icons.arrow_circle_down, color: Colors.white,), 
                )
              ),
            ),
            const SizedBox(width: 5), 
            InkWell(
              child : Container(
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
                padding : const EdgeInsets.symmetric(horizontal : 6 , vertical : 2),
                child : IconButton(
                  onPressed: () {
                    if( !spinning) {
                      resetGame() ; 
                    }
                  },
                  icon : const Icon(Icons.restart_alt, color : Colors.white), 
                )
              ),
              
            ),
            const SizedBox(width: 5), 
            InkWell(
              child : Container(
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
                padding : const EdgeInsets.symmetric(horizontal : 6 , vertical : 2),
                child : IconButton(
                  onPressed: () {
                    if( !spinning) {
                      spin() ; 
                      spinning = true ;
                    }
                  },
                  icon : const Icon(Icons.play_arrow, color : Colors.white), 
                )
              ),
              
            ),
          ],
        ),
      ),
    );
  }

  // to default 
  void resetGame() {
    setState(() {
      spinning = false;
      earnedValue = 0;
      totalEarnings = 0; 
      spins = 0;
      angle = 0;
      controller.reset();
    });
  }
}
