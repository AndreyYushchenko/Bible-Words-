import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/achievements_data.dart';
import '../models/achievement.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/achievement_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final stats = PlayerStats(
      levelsCompleted: player.data.levelsCompleted,
      wordsFound: player.data.wordsFound,
      namesLevelsCompleted: player.data.levelsCompleted,
      categoriesCompleted: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text('Досягнення', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final a = achievements[i];
          return AchievementCard(achievement: a, progress: a.progressSelector(stats));
        },
      ),
    );
  }
}
