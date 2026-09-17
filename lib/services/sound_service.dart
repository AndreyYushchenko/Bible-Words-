import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Plays short CC0 SFX (Kenney's UI Audio pack, see assets/sounds/LICENSE.txt)
/// for gameplay feedback, plus a haptic pulse alongside each one. Gated on
/// [enabled], which PlayerProvider keeps in sync with the Sound setting.
///
/// Rapid letter-drag taps can trigger several plays within the same second.
/// A single shared AudioPlayer doesn't handle overlapping stop()+play() calls
/// well on real hardware, so this round-robins across a small pool instead —
/// each call gets its own player, no two overlapping calls fight over state.
class SoundService {
  SoundService._();

  static bool enabled = true;

  static const _poolSize = 4;
  static final List<AudioPlayer> _pool = List.generate(
    _poolSize,
    (_) => AudioPlayer()..audioCache.prefix = 'assets/sounds/',
  );
  static int _next = 0;

  static Future<void> _play(String fileName) async {
    if (!enabled) return;
    try {
      final player = _pool[_next];
      _next = (_next + 1) % _poolSize;
      await player.play(AssetSource(fileName));
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
