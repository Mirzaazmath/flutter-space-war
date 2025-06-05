import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:space_war/my_game.dart';

///Here we have created a class for our shield powerBooster/pickupType.shield
class Shield extends SpriteComponent with HasGameReference<MyGame> {
  /// size: Vector2.all(200) specifying the size of the Shield with alignment
  Shield() : super(size: Vector2.all(200), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    /// Here we are loading the shield sprite in our game
    sprite = await game.loadSprite('shield.png');

    /// Here we have added the CircleHitbox to take hit
    add(CircleHitbox());

    /// Here we are creating the ScaleEffect for Shield
    final ScaleEffect pulsatingEffect = ScaleEffect.to(
      /// Size
      Vector2.all(1.1),
      EffectController(
        /// Duration
        duration: 0.6,

        /// Reverse
        alternate: true,

        /// loop
        infinite: true,

        /// Animation Curves
        curve: Curves.easeInOut,
      ),
    );

    /// Here we are adding the pulsatingEffect to our Shield component
    add(pulsatingEffect);
    return super.onLoad();
  }
}
