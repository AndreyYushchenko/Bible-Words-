import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../theme/app_theme.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.achievement, required this.progress});

  final Achievement achievement;
  final int progress;

  @override
  Widget build(BuildContext context) {
    final unlocked = progress >= achievement.target;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: unlocked ? AppColors.goldGradient : null,
              color: unlocked ? null : AppColors.lockedBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              unlocked ? achievement.icon : Icons.lock_rounded,
              size: 22,
              color: unlocked ? const Color(0xFF241408) : AppColors.lockedIcon,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: unlocked ? AppColors.textDark : AppColors.lockedIcon,
                  ),
                ),
                const SizedBox(height: 3),
                Text(achievement.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(
            '${progress.clamp(0, achievement.target)}/${achievement.target}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
