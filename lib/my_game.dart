import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_war/components/asteroid.dart';
import 'package:space_war/components/audio_manager.dart';
import 'package:space_war/components/pickup.dart';
import 'package:space_war/components/shoot_btn.dart';

import 'components/player.dart';
import 'components/star.dart';

/// HasKeyboardHandlerComponents will help us with movement of player via keyboard arrows
/// HasCollisionDetection will help us to hit the target with our laser and also indicate our game that we have Collision in our game
class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
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

  /// For Counting the score of the player
  int _score = 0;

  /// For Displaying the score to the user
  late TextComponent _scoreDisplay;

  /// Pickup/PowerBooster Spawn
  late SpawnComponent _pickupSpawn;

  /// playerColors is the list of available player options
  final List<String> playerColors = ["blue", "red", "green", "purple"];

  /// Selected player option
  int playerColorIndex = 0;

  /// Created a variable to handle audio in our game
  late final AudioManager audioManager;

  /// Here we are configuring things while loading game
  @override
  FutureOr<void> onLoad() async {
    /// Here we are setting our device in full screenMode
    await Flame.device.fullScreen();

    /// Here we are setting our device in  portraitMode
    await Flame.device.setPortrait();

    /// Here we are initializing the _audioManager
    audioManager = AudioManager();

    /// Here we are adding the music player to our game
    await add(audioManager);

    /// After adding the _audioManager we are playing the music
    audioManager.playMusic();

    /// Here we are calling the _createStars to create background for our game
    _createStars();

    // /// Here we are calling the  startGame method
    //     // startGame();

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

    /// Here we are calling the _asteroidSpawn
    _asteroidSpawn();

    /// Here we are calling the _createScoreDisplay to display the player score
    _createScoreDisplay();

    /// Here we are calling the _createPickupSpawn for powerBooster
    _createPickupSpawn();
    ;
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
      factory: (index) => Asteroid(position: _generateRandomSpawnPosition()),
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

  /// Here we have created _createScoreDisplay method  which will display the player score
  void _createScoreDisplay() {
    /// Here we are setting the _score to 0 because we want to start fresh everytime
    _score = 0;

    /// Here are creating the TextComponent
    _scoreDisplay = TextComponent(
      /// Text
      text: "0",

      /// Alignment
      anchor: Anchor.topCenter,

      /// Position  on Screen
      position: Vector2(size.x / 2, 20),

      /// Stack Position
      priority: 10,

      /// TextPaint
      textRenderer: TextPaint(
        /// TextStyle
        style: TextStyle(
          /// Color
          color: Colors.white,

          /// FontWeight
          fontWeight: FontWeight.bold,

          /// FontSize
          fontSize: 48,

          /// Shadow
          shadows: [
            Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 2),
          ],
        ),
      ),
    );

    /// Here we are adding the _scoreDisplay TextComponent into our game
    add(_scoreDisplay);
  }

  /// Here we have created the incrementScore method which will help us to increase the score with given amount
  void incrementScore(int amount) {
    /// Here we are adding the previous + newAmount
    _score += amount;

    /// Here we are setting the _scoreDisplay text with _score value
    _scoreDisplay.text = _score.toString();

    /// Here we are creating ScaleEffect to _scoreDisplay
    final ScaleEffect popEffect = ScaleEffect.to(
      /// from all size
      Vector2.all(1.2),
      EffectController(
        /// Duration
        duration: 0.05,

        /// Reverse
        alternate: true,

        /// Animation curve
        curve: Curves.easeInOut,
      ),
    );

    /// Here we have added the popEffect into _scoreDisplay Text Component
    _scoreDisplay.add(popEffect);
  }

  /// _createPickupSpawn will generate pickUp/PowerBooster Spawn
  void _createPickupSpawn() {
    /// Here we are assigning the _pickupSpawn
    /// SpawnComponent.periodRange
    ///  factory: (index)=>PickUp(position: Vector2.zero()), means the widget we want to spawn
    ///  minPeriod: 5.0,means minimum time
    ///  maxPeriod: 10.o means maximum time
    ///  selfPositioning means you will allow to use random position
    _pickupSpawn = SpawnComponent.periodRange(
      /// Here we calling the _generateRandomSpawnPosition to get every time a random position for our pickUp/PowerBooster
      factory:
          (index) => PickUp(
            position: _generateRandomSpawnPosition(),
            pickupType:
                PickupType.values[_random.nextInt(PickupType.values.length)],
          ),
      minPeriod: 5.0,
      maxPeriod: 10.0,
      selfPositioning: true,
    );

    /// Here we are adding our _pickupSpawn into our game
    add(_pickupSpawn);
  }

  /// Here we are creating the star for our game background
  void _createStars() {
    /// Here we are creating the 50 stars for background
    for (int i = 0; i < 50; i++) {
      add(Star()..priority = -10);
    }
  }

  /// Here playerDied will display a overlay of GameOver and pauseEngine when the player died
  void playerDied() {
    overlays.add("GameOver");

    /// Here we are pausing the game engine
    pauseEngine();
  }

  /// Here restartGame will again start the game
  void restartGame() {
    /// Here Before we start again our game we are clearing the previous game components
    /// like Asteroid and PickUp/PowerBoosters
    children.whereType<PositionComponent>().forEach((component) {
      if (component is Asteroid || component is PickUp) {
        remove(component);
      }
    });

    /// Here are also starting the Spawner
    /// For Asteroids
    _asteroidsSpawnComponent.timer.start();

    /// For PickUp/PowerBoosters
    _pickupSpawn.timer.start();

    /// Here we are setting the score before starting the game
    _score = 0;

    /// Here we are setting the score Display Text before starting the game
    _scoreDisplay.text = "0";

    /// Here we are _createPLayer to create a new player because previous one was destroyed
    _createPLayer();

    /// Here we are resuming the game engine
    resumeEngine();
  }

  void quitGame() {
    /// Here Before we start again our game we are clearing the previous game components
    children.whereType<PositionComponent>().forEach((component) {
      /// Here we are removing every component except Star from our screen
      if (component is! Star) {
        remove(component);
      }
    });

    /// Here we are also removing the _asteroidsSpawnComponent and _pickupSpawn from our game
    remove(_asteroidsSpawnComponent);
    remove(_pickupSpawn);

    /// Here we are adding Title overlay again like homeScreen
    overlays.add("Title");

    /// Here we are resuming the game engine
    resumeEngine();
  }
}
