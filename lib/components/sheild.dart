import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:space_war/components/asteroid.dart';
import 'package:space_war/my_game.dart';

///Here we have created a class for our shield powerBooster/pickupType.shield
class Shield extends SpriteComponent with HasGameReference<MyGame>,CollisionCallbacks {
  /// size: Vector2.all(200) specifying the size of the Shield with alignment
  Shield() : super(size: Vector2.all(200), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    /// Here we are loading the shield sprite in our game
    sprite = await game.loadSprite('shield.png');
   /// Positioning the Shield at the center of the player
    position += game.player.size/2;

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
/// Here we are adding the fadeOutEffect to warn out the Shield powerBooster
    final OpacityEffect fadeOutEffect= OpacityEffect.fadeOut(EffectController(
      ///  warn out time duration
      duration: 2.0,
      ///  start delay  time duration
      startDelay: 3.0,
    ),
      onComplete: (){
      /// Here we are removing the shield component from our game
      removeFromParent();
      /// Also we are removing the activeShield from player
      game.player.activeShield=null;
      }
    );
    /// Here we are adding the fadeOutEffect to our shield component
    add(fadeOutEffect);
    return super.onLoad();
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    /// Here we are checking the Collision
    if(other is Asteroid){
      /// if it hits the Asteroid then we are calling the takeDamage method
      other.takeDamage();
    }
  }

}
