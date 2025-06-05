import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:flutter/services.dart';
import 'package:space_war/components/asteroid.dart';
import 'package:space_war/components/laser.dart';
import 'package:space_war/my_game.dart';

/// Here we are creating  a player component with HasGameReference
/// HasGameReference provide us the GameReference so we can access the game elements
/// Here we are also added KeyboardHandler to control our game with physical
///  After Sometime we have change sprite component to SpriteAnimationComponent  for player to animate
///  Here we are also adding CollisionCallbacks to our call so it can take hits
class Player extends SpriteAnimationComponent
    with HasGameReference<MyGame>, KeyboardHandler, CollisionCallbacks {
  /// Created a variable to handle the shooting of the laser
  bool _isShooting = false;

  /// Created a variable to handle time duration between lasers
  final double _fireCoolDown = 0.2;

  /// Created a variable to check the  _fireCoolDown duration from last shoot
  double _elaspedFireTime = 0.0;

  /// Created a variable to handle keyBoardMovement in our game
  final Vector2 _keyBoardMovement = Vector2.zero();

  /// Created the bool variable to handle the Destruction
  bool _isDestroyed = false;

  @override
  FutureOr<void> onLoad() async {
    /// Here we are setting the player in sprite with the help of
    /// loadSprite method and passing the assets name
    /// it will automatically search it from assets/ images folder
    // sprite = await game.loadSprite("player_blue_on0.png");

    /// Here we are calling the _loadAnimation to load our animated sprite player
    animation = await _loadAnimation();

    /// Here we are adjusting the size of our player
    /// we have reduced the size to 1/3 of its original size
    size *= 0.3;

    /// Here we have added  RectangleHitbox to our player so it can take hits
    add(RectangleHitbox());

    return super.onLoad();
  }

  /// update will call in everyFrame of our game

  /// Here we are updating the position of our player
  @override
  void update(double dt) {
    super.update(dt);
    /// Here we are checking whether our player is hit by asteroid or not and if its already Destroy then return nothing
    if(_isDestroyed)return;

    /// Here position of our player will update
    /// position +=game.joystick.relativeDelta.normalized()*200*dt;
    /// "currentPosition +=newPositionFromJoyStick*speed"
    /// Here we have added the key arrow movement from keyboard in our game
    final Vector2 movement = game.joystick.relativeDelta + _keyBoardMovement;
    position += movement.normalized() * 200 * dt;

    /// Here we are handling the screen bound
    _handleScreenBounds();

    /// Here we are adding _elaspedFireTime to coolDown laser shoot speed
    _elaspedFireTime += dt;

    ///Here we are checking if the weather the _isShooting is started or not with _elaspedFireTime to maintain a proper duration between each laser when play long pressed the shoot button
    if (_isShooting && _elaspedFireTime >= _fireCoolDown) {
      _fireLaser();

      /// Here we are resetting the  _elaspedFireTime back to zero to maintain proper shoot duration
      _elaspedFireTime = 0.0;
    }
  }

  /// Here we are handling the bounds of our game screen
  void _handleScreenBounds() {
    /// Screen Width
    final double screenWidth = game.size.x;

    /// Screen Height
    final double screenHeight = game.size.y;

    /// Here we are preventing the player from going off the top and bottom edges(vertically)
    /// clampDouble(position.y, size.y / 2, screenHeight - size.y / 2);
    /// clampDouble    currentPosition , halfOfPlayerSize , fullScreenHeight - halfOfPlayerSize
    position.y = clampDouble(position.y, size.y / 2, screenHeight - size.y / 2);

    /// Here we are wraparound the player from going left to right and right to left if both the player exceed the screen width
    /// Checking if the player has reaching less than  the edge of left side
    if (position.x < 0) {
      /// then we are positioning the player to the edge of right side
      position.x = screenWidth;

      /// Checking if the player has reaching less than  the edge of left side
    } else if (position.x > screenWidth) {
      /// then we are positioning the player to the edge of left side
      position.x = 0;
    }
  }

  /// Here we have created a startShooting  to start shooting  the laser
  void startShooting() {
    _isShooting = true;
  }

  /// Here we have created a stopShooting  to stop  shooting the laser
  void stopShooting() {
    _isShooting = false;
  }

  /// Here we are added the Laser to our _fireLaser method
  void _fireLaser() {
    /// Here added Laser to our game with player position clone + playerHalfHeight
    game.add(Laser(position: position.clone() + Vector2(0, -size.y / 2)));
  }

  /// Here we are handling the physical keyboard KeyEvent
  /// Here we have defined which key will do what in our app
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    /// Here we are are changing horizontal movement of our player by arrowLeft and arrowRight key of physical keyboard
    _keyBoardMovement.x = 0;
    _keyBoardMovement.x +=
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ? -1 : 0;
    _keyBoardMovement.x +=
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ? 1 : 0;

    /// Here we are are changing vertical  movement of our player by arrowUp and arrowUp key of physical keyboard
    _keyBoardMovement.y = 0;
    _keyBoardMovement.y +=
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ? -1 : 0;
    _keyBoardMovement.y +=
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ? 1 : 0;

    return true;
  }

  /// Here we have created _loadAnimation which wil return the SpriteAnimation
  Future<SpriteAnimation> _loadAnimation() async {
    /// Here we are returning the SpriteAnimation with spriteList
    /// this will switch between to Sprite images so it will look
    return SpriteAnimation.spriteList(
      [
        await game.loadSprite("player_blue_on0.png"),
        await game.loadSprite("player_blue_on1.png"),
      ],
      stepTime: 0.1,
      loop: true,
    );
  }

  /// Here we have created a _handleDestruction method to destroy our player when it hit to any asteroid
  void _handleDestruction() async {
    /// Here we are adding the new SpriteAnimation for our player destruction
    animation = SpriteAnimation.spriteList([
      await game.loadSprite("player_blue_off.png"),
    ], stepTime: double.infinity);

    /// Here we are adding the ColorEffect to our player destruction
    add(
      ColorEffect(
        const Color.fromRGBO(255, 255, 255, 1.0),
        EffectController(duration: 0.0),
      ),
    );

    /// Here we are adding the OpacityEffect to our player destruction
    add(OpacityEffect.fadeOut(EffectController(duration: 3.0)));
    /// Here we are updating the _isDestroyed value
    _isDestroyed = true;
  }

  /// Here we are handling the Collision of our player by Asteroid
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

   /// Here we are checking whether our player is hit by asteroid or not and if its already Destroy then return nothing
    if(_isDestroyed)return;

    /// Here we are checking whether our player is hit by asteroid or not
    if (other is Asteroid) {
      /// if yes then we are calling the _handleDestruction
      _handleDestruction();
    }
  }
}
