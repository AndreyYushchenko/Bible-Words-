import 'package:flutter/services.dart';

/// Lightweight feedback via the system's built-in haptics/click sound —
/// no bundled audio files needed. Gate everything on [enabled], which
/// PlayerProvider keeps in sync with the player's Sound setting.
class SoundService {
  SoundService._();

  static bool enabled = true;

  static void tap() {
    if (!enabled) return;
    HapticFeedback.selectionClick();
  }

  static void wordFound() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }

  static void error() {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
  }

  static void levelComplete() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }
}
