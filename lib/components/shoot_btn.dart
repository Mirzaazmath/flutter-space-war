import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:space_war/my_game.dart';
/// Here we have created the SpriteComponent for shoot btn
class ShootButton extends SpriteComponent with HasGameReference<MyGame>,TapCallbacks{
  /// size: Vector2.all(80) means the size of the shoot button
  ShootButton():super(size: Vector2.all(80));

  @override
  FutureOr<void> onLoad()async {
    /// Here we are loading the asset image for shoot button
    sprite = await game.loadSprite("shoot_button.png");
    return super.onLoad();
  }
  /// Here we are handling the onTapDown Event
  @override
  void onTapDown(TapDownEvent event) {
    /// Whenever user tap on the shoot button we are calling
    /// startShooting to shoot the lasers
    game.player.startShooting();
    super.onTapDown(event);
  }
  /// Here we are handling the onTapUp Event
  @override
  void onTapUp(TapUpEvent event) {
    /// Whenever user remove the tap on the shoot button we are calling
    /// stopShooting to stop the lasers
    game.player.stopShooting();
    super.onTapUp(event);
  }
  /// Here we are handling the onTapCancel Event
  @override
  void onTapCancel(TapCancelEvent event) {
    /// Whenever user move away from  the shoot button we are calling
    /// stopShooting to stop the lasers
      game.player.stopShooting();
    super.onTapCancel(event);
  }

}