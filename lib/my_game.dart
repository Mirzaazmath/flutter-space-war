import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:space_war/components/asteroid.dart';

import 'components/player.dart';

class MyGame extends FlameGame {
  /// player
  late Player player;

  /// joystick
  late JoystickComponent joystick;

  /// Here we are configuring things while loading game
  @override
  FutureOr<void> onLoad() async {
    /// Here we are setting our device in full screenMode
    await Flame.device.fullScreen();

    /// Here we are setting our device in  portraitMode
    await Flame.device.setPortrait();

    /// Here we are calling the  startGame method
    startGame();

    return super.onLoad();
  }

  /// Here we are starting the game
  void startGame() async {
    /// Here we are calling _createJoyStick to create a joystick for our player
    /// note:  we have make joystick before our player
    await _createJoyStick();

    /// Here we are calling the _createPLayer to create a player
    _createPLayer();

    /// Here we are added Asteroid in our game
    add(Asteriod(position: Vector2(200, 0)));
  }

  /// Here we are creating the player and adding that player into our game
  void _createPLayer() {
    /// anchor=Anchor.center means alignment of our player
    /// position=Vector2(size.x/2, size.y/2) means position of our player at screen center
    /// size.x means horizontal (Width)
    /// size.y means vertical (Height)
    /// size = Vector2.all(100) here we are setting the size of our player
    player =
        Player()
          ..anchor = Anchor.center
          ..position = Vector2(size.x / 2, size.y * 0.8);

    /// Here we are adding our player into our game
    add(player);
  }

  /// Here we are creating the Joy stick to control our player
  Future<void> _createJoyStick() async {
    /// position=Vector2(size.x/2, size.y/2) means position of our player at screen center
    /// size.x means horizontal (Width)
    /// size.y means vertical (Height)
    /// size = Vector2.all(100) here we are setting the size of our player
    /// assign our joystick variable a JoystickComponent
    joystick =
        JoystickComponent(
            /// Here we are creating the knob of our joystick with the given size
            knob: SpriteComponent(
              sprite: await loadSprite("joystick_knob.png"),
              size: Vector2.all(50),
            ),

            /// Here we are creating the background of our joystick with the given size
            background: SpriteComponent(
              sprite: await loadSprite('joystick_background.png'),
              size: Vector2.all(100),
            ),

            /// default priority = 0;
            /// priority acts like stack
            /// we need to set priority to avoid any moving issue
            priority: 10,

            /// Here we are positioning the joystick at our game screen
          )
          ..anchor = Anchor.bottomLeft
          ..position = Vector2(20, size.y - 20);

    /// Here we are adding our joystick into our game
    add(joystick);
  }
}
