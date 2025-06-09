import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class AudioManager extends Component {
  /// Created a variable to handle the music
  bool musicEnabled = true;

  /// Created a variable to handle the Sound effect
  bool soundEnabled = true;

  /// Created a variable  with list of sound effect
  final List<String> _sounds = [
    "click",
    "collect",
    "explode1",
    "explode2",
    "fire",
    "hit",
    "laser",
    "start",
  ];
  Map<String, int> _soundIds = {};

  /// SoundPool help us to play multiple audios at same time
  final Soundpool _soundpool = Soundpool.fromOptions(
    /// Here we are specifying the maxStreams count you want
    options: const SoundpoolOptions(maxStreams: 10),
  );
  @override
  FutureOr<void> onLoad() async {
    /// Here we are initializing the  FlameAudio with bgm
    FlameAudio.bgm.initialize();

    /// Here we are looping the _sounds adding in the _soundIds
    for (String sound in _sounds) {
      _soundIds[sound] = await rootBundle.load("assets/audio/$sound.ogg").then((
        ByteData data,
      ) {
        return _soundpool.load(data);
      });
    }

    return super.onLoad();
  }

  void playMusic() {
    if (musicEnabled) {
      /// Here we are assigning the background music
      FlameAudio.bgm.play("music.ogg");
    }
  }

  void playSound(String sound) {
    if (soundEnabled) {
      /// Here we are playing the sound effect which is getting as parameter
      _soundpool.play(_soundIds[sound]!);
    }
  }

  void toggleMusic() {
    musicEnabled = !musicEnabled;
    if (musicEnabled) {
      playMusic();
    } else {
      FlameAudio.bgm.stop();
    }
  }

  void toggleSound() {
    soundEnabled = !soundEnabled;
  }
}
