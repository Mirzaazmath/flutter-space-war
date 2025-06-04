import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
    /// Here we adding the RemoveEffect this will help us to release the memory for the CircleComponent
    /// after some delay same like dispose
    add(RemoveEffect(delay: 1.0));

    return super.onLoad();
  }

/// Here we have created a _createFlash method to show the flash effect when the asteroid destroyed by laser
  void _createFlash(){
    /// Here are creating the CircleComponent with radius and paint with anchor
    final CircleComponent flash = CircleComponent(
      radius: explosionSize*0.6,
      paint: Paint()..color=const Color.fromRGBO(255, 255, 255, 1.0),
      anchor: Anchor.center
    );
    /// Here we are creating the OpacityEffect for out flash with fadeOut
    final OpacityEffect fadeOutEffect = OpacityEffect.fadeOut(EffectController(duration: 0.3));
    /// Here we have added fadeOutEffect into our flash CircleComponent
    flash.add(fadeOutEffect);
    /// Here we have added the flash CircleComponent  to our Explosion Component
    add(flash);
  }


}
