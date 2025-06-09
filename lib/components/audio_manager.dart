import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager extends Component {
  /// Created a variable to handle the music
  bool musicEnabled = true;

  /// Created a variable to handle the Sound effect
  bool soundEnabled = true;
  @override
  FutureOr<void> onLoad() {
    /// Here we are initializing the  FlameAudio with bgm
    FlameAudio.bgm.initialize();


    return super.onLoad();
  }
  void playMusic(){
    if(musicEnabled){
      /// Here we are assigning the background music
      FlameAudio.bgm.play("music.ogg");
    }

  }
}
