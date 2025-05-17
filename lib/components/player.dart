import 'dart:async';

import 'package:flame/components.dart';
/// Here we are creating  a player component with HasGameReference
/// HasGameReference provide us the GameReference so we can access the game elements
class Player extends SpriteComponent with HasGameReference{
  @override
  FutureOr<void> onLoad()async {
    /// here we are setting the player in sprite with the help of
    /// loadSprite method and passing the assets name
    /// it will automatically search it from assets/ images folder
    sprite = await game.loadSprite("player_blue_on0.png");

    return super.onLoad();
  }
}