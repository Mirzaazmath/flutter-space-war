import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:space_war/my_game.dart';

/// Here we have created the ExplosionType enum which will also help us for choosing which type of explosion we want
enum ExplosionType { dust, smoke, fire }

/// Here we have created the Explosion with  PositionComponent with GameReference of type myGame
class Explosion extends PositionComponent with HasGameReference<MyGame> {
  final ExplosionType explosionType;
  final double explosionSize;
  final Random _random = Random();

  Explosion({
    super.position,
    required this.explosionType,
    required this.explosionSize,
  });

  @override
  FutureOr<void> onLoad() {
    /// Here we are calling the _createFlash method
    _createFlash();
    _createParticles();

    /// Here we adding the RemoveEffect this will help us to release the memory for the CircleComponent
    /// after some delay same like dispose
    add(RemoveEffect(delay: 1.0));

    return super.onLoad();
  }

  /// Here we have created a _createFlash method to show the flash effect when the asteroid destroyed by laser
  void _createFlash() {
    /// Here are creating the CircleComponent with radius and paint with anchor
    final CircleComponent flash = CircleComponent(
      radius: explosionSize * 0.6,
      paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 1.0),
      anchor: Anchor.center,
    );

    /// Here we are creating the OpacityEffect for out flash with fadeOut
    final OpacityEffect fadeOutEffect = OpacityEffect.fadeOut(
      EffectController(duration: 0.3),
    );

    /// Here we have added fadeOutEffect into our flash CircleComponent
    flash.add(fadeOutEffect);

    /// Here we have added the flash CircleComponent  to our Explosion Component
    add(flash);
  }

  /// Here we are returning the List<Color> whenever _generateColors calls and the list is based on ExplosionType
  List<Color> _generateColors() {
    switch (explosionType) {
      case ExplosionType.dust:
        return [
          const Color(0xff5A4632),
          const Color(0xff68543D),
          const Color(0xff8A6E50),
        ];
      case ExplosionType.smoke:
        return [
          const Color(0xff404040),
          const Color(0xff606060),
          const Color(0xff808080),
        ];

      case ExplosionType.fire:
        return [
          const Color(0xffFFD700),
          const Color(0xffFFA500),
          const Color(0xffFFC107),
        ];
    }
  }
/// Here we have created the _createParticles method to display the particle effect after destroy the asteroid
  void _createParticles() {
    /// Here we are getting the list of Colors based on the ExplosionType
    final List<Color> colors = _generateColors();
    /// Here we have creating the ParticleSystemComponent
    final ParticleSystemComponent particles = ParticleSystemComponent(
      /// Here we are using the particle with generate
      particle: Particle.generate(
        /// Here we are passing the count  8 + _random.nextInt(5), means from 8 to 13 any random
        count: 8 + _random.nextInt(5),
        /// Here is the generator method where we have to return which Particle we want to generate
        generator: (index) {
          /// Here we are generating the MovingParticle with moving animation
          return MovingParticle(
            /// For child we are using the CircleParticle
            child: CircleParticle(
              /// Here we are passing  color from colors list with random index and we are also making the color opacity with random
              paint:
                  Paint()
                    ..color = colors[_random.nextInt(colors.length)].withValues(
                      alpha: 0.4 + _random.nextDouble() * 0.4,
                    ),
              radius: explosionSize * (0.1 + _random.nextDouble() * 0.05),
            ),
            /// Here we are passing the Vector2 for our MovingParticle with random positions
            to: Vector2(
              (_random.nextDouble() - 0.5) * explosionSize * 2,
              (_random.nextDouble() - 0.5) * explosionSize * 2,
            ),
            /// Here we have defined the lifespan with random its around 0.5 to 1 second
            lifespan: 0.5 + _random.nextDouble() * 0.5,
          );
        },
      ),
    );
    /// Here we have added the particles to our Explosion Component
    add(particles);
  }
}
