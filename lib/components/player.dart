import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:space_war/components/laser.dart';
import 'package:space_war/my_game.dart';

/// Here we are creating  a player component with HasGameReference
/// HasGameReference provide us the GameReference so we can access the game elements
class Player extends SpriteComponent with HasGameReference<MyGame> {
  /// Created a variable to handle the shooting of the laser
  bool _isShooting = false;
  @override
  FutureOr<void> onLoad() async {
    /// here we are setting the player in sprite with the help of
    /// loadSprite method and passing the assets name
    /// it will automatically search it from assets/ images folder
    sprite = await game.loadSprite("player_blue_on0.png");

    /// Here we are adjusting the size of our player
    /// we have reduced the size to 1/3 of its original size
    size *= 0.3;

    return super.onLoad();
  }

  /// update will call in everyFrame of our game

  /// Here we are updating the position of our player
  @override
  void update(double dt) {
    super.update(dt);

    /// Here position of our player will update
    /// position +=game.joystick.relativeDelta.normalized()*200*dt;
    /// "currentPosition +=newPositionFromJoyStick*speed"
    position += game.joystick.relativeDelta.normalized() * 200 * dt;
    /// Here we are handling the screen bound
    _handleScreenBounds();
    ///Here we are checking if the weather the _isShooting is started or not
     if(_isShooting){
       _fireLaser();
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
  void _fireLaser(){
    /// Here added Laser to our game with player position clone + playerHalfHeight
  game.add(Laser(position: position.clone()+Vector2(0,-size.y/2)));
  }
}
