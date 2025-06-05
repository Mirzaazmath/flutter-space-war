import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_war/my_game.dart';
import 'package:space_war/overlays/game_over_overlay.dart';

void main() {
  // 55:00
  final MyGame game = MyGame();
  runApp(
    GameWidget(
      game: game,
      /// Here we are adding the overlay
      overlayBuilderMap: {
        "GameOver": (context, MyGame game) => GameOverOverlay(game: game),
      },
    ),
  );
}
