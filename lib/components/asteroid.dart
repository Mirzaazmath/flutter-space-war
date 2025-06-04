import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:space_war/components/explosion.dart';
import 'package:space_war/my_game.dart';

/// Class to Create asteroids
class Asteroid extends SpriteComponent with HasGameReference<MyGame> {
  /// Here we have created a _random variable of type Random()
  /// for our random asteroids
  final Random _random = Random();

  /// Maximum size for an asteroid
  static const double _maxSize = 120;

  /// Velocity for our Falling asteroids
  late Vector2 _velocity;

  /// for handling the speed of the spin of asteroid
  late double _spinSpeed;

  /// the maximum health of the asteroid for large one
  final double _maxHealth = 3;

  /// this will hold the current health of our asteroid
  late double _health;

  /// _originalVelocity will help us to track the _velocity for our asteroid
  final Vector2 _originalVelocity = Vector2.zero();

  ///  _isKnockBack will handle the bounce back effect when user hit the asteroid multiple times
  bool _isKnockBack = false;

  /// Here we have created a constructor with one required that is position
  /// and  with some default value like size and anchor
  /// size: Vector2.all(120), means size of our Asteriod
  /// anchor: Anchor.center Alignment of our  Asteriod
  /// _health = size/_maxSize*_maxHealth;  will define the health of the asteroid
  Asteroid({required super.position, double size = _maxSize})
    : super(size: Vector2.all(size), anchor: Anchor.center, priority: -1) {
    _velocity = _generateVelocity();

    /// Here we are setting the _originalVelocity from _velocity to track the asteroid falling velocity
    _originalVelocity.setFrom(_velocity);
    _spinSpeed = _random.nextDouble() * 1.5 - 0.75;
    _health = size / _maxSize * _maxHealth;

    /// Here we have added the CircleHitbox to our Asteriod to handle collision
    add(CircleHitbox());
  }

  @override
  FutureOr<void> onLoad() async {
    /// Here we generating the random number from 0 till 2 adding +1 to it so it starts from 1 and end at 3
    /// we are generating because of Asteriod image that we have in assets range from 1 to 3
    final int imageNum = _random.nextInt(3) + 1;

    /// Here we are loading the sprite of our asteroid
    sprite = await game.loadSprite("asteroid$imageNum.png");
    return super.onLoad();
  }

  /// update will call in everyFrame of our game

  /// Here we are updating the position of our asteroids
  @override
  void update(double dt) {
    /// Here position of our asteroids will update
    ///  position.y +=150*dt;
    /// "verticalCurrentPosition +=newVerticalPosition*speed"
    position += _velocity * dt;

    /// Here we are calling the _handleScreenBounds to handle the Bounds of our screen for asteroids
    _handleScreenBounds();

    /// Here we are handling the spin speed the asteroid
    angle += _spinSpeed * dt;

    super.update(dt);
  }

  /// Here We are return random Velocity( for asteroids
  Vector2 _generateVelocity() {
    final double forceFactor = _maxSize / size.x;
    return Vector2(
          _random.nextDouble() * 120 - 60,
          100 + _random.nextDouble() * 50,
        ) *
        forceFactor;
  }

  void _handleScreenBounds() {
    /// Here are checking the vertical position of our asteroid if it exceed the height of the screen
    if (position.y > game.size.y + size.y / 2) {
      /// then we are removing that asteroid from memory of our device
      removeFromParent();
    }

    final double screenWidth = game.size.x;

    /// Here we are checking the asteroid exceed the width of the screen from either
    /// we are switching position so that it can be visible exactly like player
    if (position.x < -size.x / 2) {
      position.x = screenWidth + size.x / 2;
    } else if (position.x > screenWidth + size.x / 2) {
      position.x = -size.x / 2;
    }
  }

  /// Here we have created the takeDamage method to reduse our asteroid health and when it reach to 0 then we will remove that asteroid from our game
  void takeDamage() {
    /// Here we are decreasing the _health by 1 whenever laser hits the asteroid
    _health--;

    /// Here are checking the _health if it less then or equal to 0
    if (_health <= 0) {
      /// Then we are simply removing the asteroid from or game
      removeFromParent();

      /// Here we are calling the _createExplosion to show the Explosion once the asteroid destroyed
      _createExplosion();

      /// Here we are calling  the _splitAsteroid to split the asteroid into small fragments
      _splitAsteroid();

      /// Here are calling the incrementScore from game component and passing the amount 2 when the asteroid destroyed
      game.incrementScore(2);
    } else {
      /// Here we are calling the _flashWhite method for flash effect
      _flashWhite();

      /// Here we are calling the _applyKnockBack for bounce back effect
      _applyKnockBack();

      /// Here are calling the incrementScore from game component and passing the amount 1 when the asteroid takes the damage
      game.incrementScore(1);
    }
  }

  /// Here we have created the _flashWhite method
  void _flashWhite() {
    /// Here we have created the ColorEffect with white color and EffectController
    final ColorEffect flashEffect = ColorEffect(
      const Color.fromRGBO(255, 255, 255, 1.0),
      /// alternate means reverse
      EffectController(duration: 0.1, alternate: true, curve: Curves.easeInOut),
    );

    /// Here we have added the flashEffect into our asteroid component in our game
    add(flashEffect);
  }

  /// Here we have created _applyKnockBack to add the bounce back Effect ot our asteroid whenever it hits
  void _applyKnockBack() {
    /// Here we are checking the _isKnockBack is true or not to prevent the same bounce effect for every hit
    if (_isKnockBack) return;

    /// Here wer are changing the_isKnockBack value
    _isKnockBack = true;

    /// Here we are setting the asteroid velocity to zero
    _velocity.setZero();

    /// Here we have created the knockBackEffect for our bounce back Effect
    /// MoveByEffect( position , controller)
    final MoveByEffect knockBackEffect = MoveByEffect(
      Vector2(0, -20),
      EffectController(duration: 0.1),

      /// Here onComplete we are calling _restoreVelocity
      onComplete: _restoreVelocity,
    );

    /// Here we added the knockBackEffect in our asteroid component
    add(knockBackEffect);
  }

  /// Here we have created the _restoreVelocity to restore our velocity of asteroid
  /// component after the bounce back effect
  void _restoreVelocity() {
    /// Here we are again setting the _velocity with _originalVelocity
    _velocity.setFrom(_originalVelocity);

    /// Here wer are changing the_isKnockBack value
    _isKnockBack = false;
  }

  /// Here we have created _createExplosion method to show the Explosion
  void _createExplosion() {
    /// Here we are creating the Explosion with ExplosionType.dust, explosionSize,position of the asteroid
    final Explosion explosion = Explosion(
      explosionType: ExplosionType.dust,
      explosionSize: size.x,
      position: position.clone(),
    );

    /// Here we have added our explosion in our game component
    game.add(explosion);
  }

  /// Here we have created _splitAsteroid to slit the asteroid into small fragments
  void _splitAsteroid() {
    /// Here we are checking the size of the asteroid if it is small then we are simple return nothing
    if (size.x <= _maxSize / 3) return;

    /// if the asteroid is big then we are creating the 3 smaller fragment from that asteroid via looping
    for (int i = 0; i < 3; i++) {
      /// Here we are creating small fragment with same position and smaller size
      final Asteroid fragment = Asteroid(
        position: position.clone(),
        size: size.x - _maxSize / 3,
      );

      /// Here we are adding the fragment into our game
      game.add(fragment);
    }
  }
}
