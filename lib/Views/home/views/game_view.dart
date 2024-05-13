import 'dart:math' as math;
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/JSON/winnings.dart';
import 'package:spinningwheel/SQLite/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  final Users user;
  const GameView({Key? key, required this.user}) : super(key: key);

  @override
  State<GameView> createState() => _GameState();
}

class _GameState extends State<GameView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late DatabaseHelper _databaseHelper;
  List<String> sectors = [
    "Accessoire pour téléphone",
    "Crédit téléphonique",
    "Gadget technologique",
    "Application premium",
    "Forfait téléphonique",
    "Consultation technique",
    "Cours en ligne",
    "Accessoire de bureau",
    "Carte SIM prépayée",
    "Accessoire de voyage"
  ];
  int randomSectorIndex = -1;
  List<double> sectorRadians = [];
  double angle = 0;

  bool spinning = false;
  String earnedItem = "";
  int spins = 0;

  math.Random random = math.Random();

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    generateSectorRadians();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
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
          recordStats();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: const Color.fromARGB(255, 35, 153, 207),
      child: _gameContent(),
    );
  }

  Widget _gameContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox( ), 
        _wheel(),
        _gameStats(),
        _gameActions(),
      ],
    );
  }

  Widget _wheel() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 2),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.8,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/belt.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: InkWell(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: controller.value * angle,
              child: Container(
                margin: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.04),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/wheel.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
        onTap: () {
          setState(() {
            if (!spinning) {
              spin();
              spinning = true;
            }
          });
        },
      ),
    );
  }

  void spin() {
    int newRandomIndex;
    do {
      newRandomIndex = random.nextInt(sectors.length);
    } while (newRandomIndex == randomSectorIndex); // Vérifiez que le nouvel index est différent de l'index précédent
    
    randomSectorIndex = newRandomIndex;
    double randomRadian = generateRandomRadianToSpinTo();
    controller.reset();
    angle = randomRadian;
    controller.forward();
  }


  double generateRandomRadianToSpinTo() {
    return sectorRadians[randomSectorIndex] +
        (2 * math.pi * sectors.length);
  }

  void generateSectorRadians() {
    double sectorAngle = 2 * math.pi / sectors.length;
    for (int i = 0; i < sectors.length; i++) {
      sectorRadians.add(sectorAngle * (i + 1));
    }
  }

  void recordStats() async {
    earnedItem = sectors[sectors.length - randomSectorIndex - 1];
    spins += 1;
    Winnings winning = Winnings(
      usrId: widget.user.id,
      item: earnedItem,
      date: DateTime.now().toString(),
      description: "Gains",
    );
    await _databaseHelper.addWinning(winning);
  }

  Widget _gameStats() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: CupertinoColors.systemYellow,
          width: 2,
        ),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 180, 174, 17),
            Color(0XFFf8009e),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Table(
        border: TableBorder.all(color: CupertinoColors.systemYellow),
        children: [
          TableRow(children: [
            _titleColumn("Gagné"),
            _titleColumn("Tours"),
          ]),
          TableRow(children: [
            _valueColumn(earnedItem),
            _valueColumn(spins),
          ]),
        ],
      ),
    );
  }

  Column _titleColumn(String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Column _valueColumn(var value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _gameActions() {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.05,
          left: 20,
          right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: CupertinoColors.systemYellow,
                  width: 2,
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 180, 174, 17),
                    Color(0XFFf8009e),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: IconButton(
                onPressed: () {
                  if (!spinning) {
                    resetGame();
                  }
                },
                icon: const Icon(Icons.restart_alt, color: Colors.white),
              ),
            ),
          ),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: CupertinoColors.systemYellow,
                  width: 2,
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 180, 174, 17),
                    Color(0XFFf8009e),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: IconButton(
                onPressed: () {
                  if (!spinning) {
                    spin();
                    spinning = true;
                  }
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      spinning = false;
      spins = 0;
      angle = 0;
      earnedItem = "" ; 
      controller.reset();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
