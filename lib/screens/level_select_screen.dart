import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/categories_data.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/coin_badge.dart';
import '../widgets/level_cell.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final category = categoryById(categoryId);
    final levels = levelsForCategory(categoryId);
    final player = context.watch<PlayerProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // Фоновий градієнт
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD4C09A), Color(0xFFFAF8F2)],
              ),
            ),
          ),
          // Декоративний пейзаж вгорі
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: CustomPaint(painter: _LevelBgPainter()),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded, size: 28),
                        color: AppColors.textDark,
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CoinBadge(amount: player.coins),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Заголовок і цитата
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${category.totalLevels} рівнів', style: AppTheme.display(size: 26)),
                      const SizedBox(height: 8),
                      const Text(
                        '«Пізнавайте Його через імена, які змінили історію»',
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: AppColors.textMuted, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Сітка рівнів
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: category.totalLevels,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final number = index + 1;
                      final level = index < levels.length ? levels[index] : null;
                      final unlocked = level != null && (index == 0 || player.starsFor(levels[index - 1].id) > 0);
                      final stars = level != null ? player.starsFor(level.id) : 0;
                      final isCurrentLevel = unlocked && stars == 0 && (index == 0 || player.starsFor(levels[index - 1].id) > 0);
                      return LevelCell(
                        number: number,
                        stars: stars,
                        locked: !unlocked,
                        selected: isCurrentLevel,
                        onTap: level == null ? null : () => context.push('/category/$categoryId/level/${level.id}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Силуети колон і міста
    paint.color = const Color(0xFFC4A870).withOpacity(0.4);
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.1, size.height * 0.2);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.35, size.height * 0.3);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.65, size.height * 0.25);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.15);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
