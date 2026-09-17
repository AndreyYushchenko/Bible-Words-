import 'package:audioplayers/audioplayers.dart';

class MusicService {
  MusicService._();

  static final AudioPlayer _player = AudioPlayer()..audioCache.prefix = 'assets/audio/';
  static bool _enabled = false;
  static bool _initialized = false;

  static set enabled(bool value) {
    _enabled = value;
    if (_enabled) {
      _play();
    } else {
      _player.pause();
    }
  }

  static Future<void> _play() async {
    if (!_enabled) return;
    try {
      if (!_initialized) {
        _player.setReleaseMode(ReleaseMode.loop);
        _initialized = true;
      }
      if (_player.state != PlayerState.playing) {
        await _player.play(AssetSource('bg_music.mp3'), volume: 0.3); // Фонова музика має бути тихою
      }
    } catch (_) {
      // Ігноруємо помилки аудіо
    }
  }

  static void pause() {
    _player.pause();
  }

  static void resume() {
    if (_enabled) {
      _play();
    }
  }
}
