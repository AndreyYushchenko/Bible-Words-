import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Plays short CC0 SFX (Kenney's UI Audio pack, see assets/sounds/LICENSE.txt)
/// for gameplay feedback, plus a haptic pulse alongside each one. Gated on
/// [enabled], which PlayerProvider keeps in sync with the Sound setting.
class SoundService {
  SoundService._();

  static bool enabled = true;

  static final AudioPlayer _player = AudioPlayer()..audioCache.prefix = 'assets/sounds/';

  static Future<void> _play(String fileName) async {
    if (!enabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(fileName));
    } catch (_) {
      // Best-effort: a missing/unsupported audio backend shouldn't crash gameplay.
    }
  }

  static void tap() {
    if (!enabled) return;
    HapticFeedback.selectionClick();
    _play('tap.wav');
  }

  static void wordFound() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    _play('success.wav');
  }

  static void error() {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
    _play('error.wav');
  }

  static void levelComplete() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    _play('level_complete.wav');
  }
}
