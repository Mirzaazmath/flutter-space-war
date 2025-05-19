import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:space_war/my_game.dart';

/// Class to Create asteroids
class Asteriod extends SpriteComponent with HasGameReference<MyGame> {
  /// Here we have created a _random variable of type Random()
  /// for our random asteroids
  final Random _random = Random();

  /// Maximum size for an asteroid
  static const double _maxSize = 120;

  /// Velocity for our Falling asteroids
  late Vector2 _velocity;

  /// Here we have created a constructor with one required that is position
  /// and  with some default value like size and anchor
  /// size: Vector2.all(120), means size of our Asteriod
  /// anchor: Anchor.center Alignment of our  Asteriod
  Asteriod({required super.position, double size = _maxSize})
    : super(size: Vector2.all(size), anchor: Anchor.center, priority: -1) {
    _velocity = _generateVelocity();
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

    /// Here are checking the vertical position of our asteroid if it exceed the height of the screen
    if (position.y > game.size.y + size.y / 2) {
      /// then we are removing that asteroid from memory of our device
      removeFromParent();
    }

    super.update(dt);
  }

  /// Here We are return random Velocity( for asteroids
  Vector2 _generateVelocity() {
    final double forceFactor =_maxSize/size.x;
    return Vector2(
      _random.nextDouble() * 120 - 60,
      100 + _random.nextDouble() * 50,
    )*forceFactor;
  }
}
