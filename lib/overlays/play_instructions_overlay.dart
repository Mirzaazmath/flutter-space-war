import 'package:flutter/material.dart';

import '../my_game.dart';

class PlayInstructionsOverlay extends StatefulWidget {
  final MyGame game;
  const PlayInstructionsOverlay({super.key, required this.game});

  @override
  State<PlayInstructionsOverlay> createState() =>
      _PlayInstructionsOverlayState();
}

class _PlayInstructionsOverlayState extends State<PlayInstructionsOverlay> {
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
      onEnd: () {
        /// Here we are checking the _opacity value if it return to 0
        /// when user clicks on the play  button
        if (_opacity == 0.0) {
          /// Here we are remove the overlay  from our PlayInstructions
          widget.game.overlays.remove("PlayInstructions");
        }
      },
      opacity: _opacity,
      duration: Duration(milliseconds: 500),
      child: Center(
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "How to Play",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 38,
              ),
            ),

            buildRow("A", "←", "To Move Left"),

            buildRow("D", "→", "To Move Right"),

            buildRow("W", "↑", "To Move Up"),

            buildRow("Z", "↓", "To Move Down"),

            buildRow("Q", "L", "To Shoot Lasers"),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                widget.game.overlays.add("Title");

                /// Here we are setting the _opacity back to 0
                setState(() {
                  _opacity = 0.0;
                });
              },
              child: Text(
                "Back!",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildKeyContainer(String val) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white),
      ),
      alignment: Alignment.center,
      child: Text(
        val,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  buildRow(String key1, String key2, String description) {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildKeyContainer(key1),
          SizedBox(width: 20),
          buildKeyContainer(key2),
          SizedBox(width: 20),
          Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
