import 'package:flutter/material.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.target,
    required this.progressSelector,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final int target;

  /// Reads the current progress value for this achievement out of the player's stats.
  final int Function(PlayerStats stats) progressSelector;
}

/// Minimal read-only view of player stats needed to compute achievement progress.
class PlayerStats {
  const PlayerStats({
    required this.levelsCompleted,
    required this.wordsFound,
    required this.namesLevelsCompleted,
    required this.categoriesCompleted,
  });

  final int levelsCompleted;
  final int wordsFound;
  final int namesLevelsCompleted;
  final int categoriesCompleted;
}
