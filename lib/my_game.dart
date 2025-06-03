import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:space_war/components/asteroid.dart';
import 'package:space_war/components/shoot_btn.dart';

import 'components/player.dart';

/// HasKeyboardHandlerComponents will help us with movement of player via keyboard arrows
class MyGame extends FlameGame  with HasKeyboardHandlerComponents{
  /// player
  late Player player;

  /// joystick
  late JoystickComponent joystick;

  /// Asteroids Spawn
  late SpawnComponent _asteroidsSpawnComponent;

  /// For Random Spawning of the Asteroids
  final Random _random = Random();

  /// ShootButton
  late ShootButton _shootButton;

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
    await _createPLayer();

    /// Here we are calling the _createShootButton to create a shooter
    _createShootButton();

    /// Here we are Calling the _asteroidSpawn
    _asteroidSpawn();
  }

  /// Here we are creating the player and adding that player into our game
  Future<void> _createPLayer() async {
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

  /// _asteroidSpawn will generate asteroid Spawn
  void _asteroidSpawn() {
    /// Here we are assigning the _asteroidsSpawnComponent
    /// SpawnComponent.periodRange
    ///  factory: (index)=>Asteriod(position: Vector2.zero()), means the widget we want to spawn
    ///  minPeriod: 0.7,means minimum time
    ///  maxPeriod: 1.6 means maximum time
    ///  selfPositioning means you will allow to use random position
    _asteroidsSpawnComponent = SpawnComponent.periodRange(
      /// Here we calling the _generateRandomSpawnPosition to get every time a random position for our asteroid
      factory: (index) => Asteriod(position: _generateRandomSpawnPosition()),
      minPeriod: 0.7,
      maxPeriod: 1.6,
      selfPositioning: true,
    );

    /// Here we are adding our _asteroidsSpawnComponent into our game
    add(_asteroidsSpawnComponent);
  }

  /// _generateRandomSpawnPosition will generate the random position for our asteroid and return Vector2
  Vector2 _generateRandomSpawnPosition() {
    ///Vector2(10+_random.nextDouble()*(size.x-10*2), -100);
    ///Vector2(10Px+RandomFrom(0,1)*ScreenWidth-10px*2,-100FromTop );
    return Vector2(10 + _random.nextDouble() * (size.x - 10 * 2), -100);
  }

  /// _createShootButton will create a shooter in our game so user can shoot the laser at asteroids
  /// ..anchor = Anchor.bottomRight means Alignment
  /// ..position = Vector2(size.x - 20, size.y - 20) means position of our shooter at screen
  /// ..priority = 10 means the stack position of our shooter
  void _createShootButton() {
    _shootButton =
        ShootButton()
          ..anchor = Anchor.bottomRight
          ..position = Vector2(size.x - 20, size.y - 20)
          ..priority = 10;
    add(_shootButton);
  }
}
