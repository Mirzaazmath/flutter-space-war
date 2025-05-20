import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_war/my_game.dart';
/// Here we have created the SpriteComponent for shoot btn
class ShootButton extends SpriteComponent with HasGameReference<MyGame>{
  /// size: Vector2.all(80) means the size of the shoot button
  ShootButton():super(size: Vector2.all(80));

  @override
  FutureOr<void> onLoad()async {
    /// Here we are loading the asset image for shoot button
    sprite = await game.loadSprite("shoot_button.png");
    return super.onLoad();
  }

}