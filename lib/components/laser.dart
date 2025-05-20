import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_war/my_game.dart';

/// Here we have create a  SpriteComponent class for laser that help us to shoot the asteroids
class Laser extends SpriteComponent with HasGameReference<MyGame> {
  ///anchor: Anchor.center, means align of the laser
  ///priority: -1  means stack position
  Laser({required super.position}) : super(anchor: Anchor.center, priority: -1);
  @override
  FutureOr<void> onLoad() async {
    /// Here we are loading the laser sprite from our assets
    sprite = await game.loadSprite("laser.png");
    /// Here we have shrink the size of our lasers
    size *= 0.25;
    return super.onLoad();
  }

  void update(dt) {
    /// Here we are updating the position of our laser
    position.y -= 500 * dt;
     /// Here we are checking the laser position if exceed or not
    if (position.y < -size.y / 2) {
      /// Here we are removing the laser if it exceed the device height to reduse the memory load of our device
      removeFromParent();
    }
    super.update(dt);
  }
}
