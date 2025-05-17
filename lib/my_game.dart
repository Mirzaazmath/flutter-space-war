import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame {
  /// Here we are configuring things while loading game
  @override
  FutureOr<void> onLoad() async {
    /// here we are setting our device in full screenMode
    await Flame.device.fullScreen();

    /// here we are setting our device in  portraitMode
    await Flame.device.setPortrait();

    return super.onLoad();
  }


}
