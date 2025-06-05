import 'dart:math';

import 'package:flame/components.dart';
import 'package:space_war/my_game.dart';
import 'package:flutter/material.dart';

/// Here we have created a class name Star for handling the background moving star sky
class Star extends CircleComponent with HasGameReference<MyGame> {
  /// Created _random for Random
  final Random _random = Random();

  /// Created _maxSize for maximum size of the star
  final int _maxSize = 3;

  /// Created _speed to handle the star speed
  late double _speed;
  @override
  Future<void> onLoad() {
    /// Here we are creating the random size from 1 to 3
    size = Vector2.all(1.0 + _random.nextInt(_maxSize));

    /// Here we are getting the random position in screen for our star
    position = Vector2(
      _random.nextDouble() + game.size.x,
      _random.nextDouble() + game.size.y,
    );

    /// Here we are defining the random _speed for every star
    _speed = size.x * (40 + _random.nextInt(10));

    /// Here we are provide color of the star based on how far they placed
    paint.color = Color.fromRGBO(255, 255, 255, size.x / _maxSize);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += _speed * dt;

    /// if the star has reached the bottom, move it o the top and give it a new X position
    if (position.y > game.size.y + size.y / 2) {
      position.y = -size.y / 2;
      position.x = _random.nextDouble() * game.size.x;
    }
  }
}
