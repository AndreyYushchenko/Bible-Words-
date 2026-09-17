import 'dart:math' as math;
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          _HexBadge(icon: achievement.icon, unlocked: unlocked),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: unlocked ? AppColors.textDark : AppColors.lockedIcon,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  achievement.subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (!unlocked)
            const Icon(Icons.lock_rounded, size: 18, color: AppColors.lockedIcon),
        ],
      ),
    );
  }
}

class _HexBadge extends StatelessWidget {
  const _HexBadge({required this.icon, required this.unlocked});
  final IconData icon;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: CustomPaint(
        painter: _HexPainter(unlocked: unlocked),
        child: Center(
          child: Icon(
            icon,
            size: 22,
            color: unlocked ? const Color(0xFF241408) : AppColors.lockedIcon,
          ),
        ),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  const _HexPainter({required this.unlocked});
  final bool unlocked;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 1;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    if (unlocked) {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      paint.shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.goldLight, AppColors.goldDark],
      ).createShader(rect);
    } else {
      paint.shader = null;
      paint.color = AppColors.lockedBg;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HexPainter old) => old.unlocked != unlocked;
}
