import 'package:flutter/material.dart';
import 'package:space_war/my_game.dart';

class GameOverOverlay extends StatefulWidget {
  final MyGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  
  double _opacity=0.0;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0),(){
      setState(() {
        _opacity=1.0;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      onEnd: (){
        /// Here we are checking the _opacity value if it return to 0
        /// when user clicks on the play again button
        if(_opacity==0.0){
          /// Here we are remove the overlay from our game
          widget.game.overlays.remove("GameOver");
        }
      },
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Container(
        color: Colors.black.withAlpha(150),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "GAME OVER",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                /// Here are calling the restartGame method to play again
                widget.game.restartGame();
                /// Here we are setting the _opacity = 0;
                setState(() {
                  _opacity=0.0;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "PLAY AGAIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "QUIT GAME",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
