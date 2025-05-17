import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_war/my_game.dart';
/// Here we are creating  a player component with HasGameReference
/// HasGameReference provide us the GameReference so we can access the game elements
class Player extends SpriteComponent with HasGameReference<MyGame>{
  @override
  FutureOr<void> onLoad()async {
    /// here we are setting the player in sprite with the help of
    /// loadSprite method and passing the assets name
    /// it will automatically search it from assets/ images folder
    sprite = await game.loadSprite("player_blue_on0.png");
    /// Here we are adjusting the size of our player
    /// we have reduced the size to 1/3 of its original size
    size*=0.3;

    return super.onLoad();
  }
  /// Here we are updating the position of our player
  @override
  void update(double dt) {
    super.update(dt);
    /// Here position of our player will update
    /// position +=game.joystick.relativeDelta.normalized()*200*dt;
    /// "currentPosition +=newPositionFromJoyStick*speed"
    position +=game.joystick.relativeDelta.normalized()*200*dt;

  }
}