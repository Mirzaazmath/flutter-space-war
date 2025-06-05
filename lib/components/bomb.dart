import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:space_war/components/asteroid.dart';
import 'package:space_war/my_game.dart';

/// Here we have created Bomb class that extends SpriteComponent with HasGameReference of myGame and also CollisionCallbacks
class Bomb extends SpriteComponent with HasGameReference<MyGame>,CollisionCallbacks{
  Bomb({required super.position}):super(size: Vector2.all(1),anchor: Anchor.center);
  @override
  FutureOr<void> onLoad()async {
    /// Here we are loading the bomb sprite
    sprite = await game.loadSprite("bomb.png");
    /// Here we are adding the CircleHitbox to our bomb component
    add(CircleHitbox());
    /// Here we have added the no of Effect in order by using SequenceEffect
    add(SequenceEffect([
      /// This SizeEffect will increase the Size of the bomb
      SizeEffect.to(Vector2.all(800), EffectController(
        /// Duration
        duration: 1.0,
        /// Animation Curves
        curve: Curves.easeInOut,
      )),
      /// This OpacityEffect will fade out the bomb with given duration
      OpacityEffect.fadeOut(EffectController(duration: 0.5)),
      /// Finally we are Removing the Effect of the bomb
      RemoveEffect(),
    ]));
    return super.onLoad();
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    /// Here we are checking the bomb is hit by Asteroid or not
    if(other is Asteroid){
      /// if yes then we are calling takeDamage,method
      other.takeDamage();
    }
  }

}