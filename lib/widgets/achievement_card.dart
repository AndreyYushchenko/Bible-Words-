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
    final id = achievement.id.replaceAll('-', '_');
    final bgImage = 'assets/images/bg_ach_$id.jpg';

    return Container(
      height: 84,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Фото фон
            Image(
              image: ResizeImage(AssetImage(bgImage), width: 800),
              fit: BoxFit.cover,
              color: unlocked ? null : Colors.grey,
              colorBlendMode: unlocked ? null : BlendMode.saturation,
            ),
            // Темне накладення
            Container(
              color: unlocked ? const Color(0x991E1A14) : const Color(0xD91E1A14),
            ),
            // Контент
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _HexBadge(icon: achievement.icon, unlocked: unlocked),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          achievement.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: unlocked ? Colors.white : Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          achievement.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: unlocked ? Colors.white70 : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!unlocked)
                    const Icon(Icons.lock_rounded, size: 20, color: Colors.white38),
                ],
              ),
            ),
          ],
        ),
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
