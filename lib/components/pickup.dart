import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:space_war/my_game.dart';

/// Here we have created an enum to pickup/powerBooster
enum PickupType { bomb, laser, shield }

/// Here we have created the PickUp  class extends SpriteComponent with HasGameReference of type MyGame
///
class PickUp extends SpriteComponent with HasGameReference<MyGame> {
  final PickupType pickupType;

  PickUp({required super.position, required this.pickupType})
    : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    /// Here we are loading the sprite for our pickup/powerBooster by given pickupType
    sprite = await game.loadSprite("${pickupType.name}_pickup.png");

    /// Here we are also adding the CircleHitbox to get the pickup/powerBooster a hit
    add(CircleHitbox());

    /// Here we are adding the ScaleEffect to our pickup/powerBooster component
    final ScaleEffect pulsatingEffect = ScaleEffect.to(
      /// Here we are defining the size  of how much the Scale would go
      /// as of now we are shrink it to its 80% of its actual size
      Vector2.all(0.9),

      /// Here we are defining the Controller for our effect
      EffectController(
        /// duration
        duration: 0.6,

        /// Reverse
        alternate: true,

        /// Loop
        infinite: true,

        /// animation
        curve: Curves.easeInOut,
      ),
    );

    /// Here we are adding our pulsatingEffect to our pickup/powerBooster component
    add(pulsatingEffect);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    /// Here we also updating the position of our pickup/powerBooster from top to bottom
    position.y += 300 * dt;

    /// Here we are checking the pickup/powerBooster reached the bottom or not
    if (position.y > game.size.y + size.y / 2) {
      /// if yes the we are removeFromParent
      /// So it will release the memory for that pickup/powerBooster and dispose that completely
      removeFromParent();
    }
  }
}
