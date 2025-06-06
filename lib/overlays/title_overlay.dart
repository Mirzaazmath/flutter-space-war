import 'package:flutter/material.dart';
import 'package:space_war/my_game.dart';

class TitleOverlay extends StatefulWidget {
  final MyGame game;
  const TitleOverlay({super.key, required this.game});

  @override
  State<TitleOverlay> createState() => _TitleOverlayState();
}

class _TitleOverlayState extends State<TitleOverlay> {
  double _opacity = 0.0;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      onEnd: (){
        /// Here we are checking the _opacity value if it return to 0
        /// when user clicks on the play  button
        if(_opacity==0.0){
          /// Here we are remove the overlay  from our game
          widget.game.overlays.remove("Title");
        }
      },
      opacity: _opacity,
      duration: Duration(milliseconds: 500),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 60),
            SizedBox(width: 270, child: Image.asset("assets/images/title.png")),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Transform.flip(
                    flipX: true,
                    child: SizedBox(
                      width: 30,
                      child: Image.asset("assets/images/arrow_button.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: 100,
                    child: Image.asset("assets/images/player_blue_off.png"),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    width: 30,
                    child: Image.asset("assets/images/arrow_button.png"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                /// Here we are starting the game
                widget.game.startGame();

                /// Here we are setting the _opacity back to 0
                setState(() {
                  _opacity = 0.0;
                });
              },
              child: SizedBox(
                width: 200,
                child: Image.asset("assets/images/start_button.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
