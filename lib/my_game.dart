import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'components/player.dart';

class MyGame extends FlameGame {
  late Player player;

  /// Here we are configuring things while loading game
  @override
  FutureOr<void> onLoad() async {
    /// Here we are setting our device in full screenMode
    await Flame.device.fullScreen();

    /// Here we are setting our device in  portraitMode
    await Flame.device.setPortrait();

    /// Here we are calling the  startGame method
    startGame();

    return super.onLoad();
  }

  /// Here we are starting the game
  void startGame() {
    /// Here we are calling the _createPLayer to create a player
    _createPLayer();
  }

  /// Here we are creating the player and adding that player into our game
  void _createPLayer() {
    /// anchor=Anchor.center means alignment of our player
    /// position=Vector2(size.x/2, size.y/2) means position of our player at screen
    /// size.x means horizontal (Width)
    /// size.y means vertical (Height)
    player = Player()..anchor=Anchor.center..position=Vector2(size.x/2, size.y/2);
    add(player);
  }
}
