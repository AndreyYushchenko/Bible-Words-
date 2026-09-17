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
          // Фото вгорі
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Image.asset(
              'assets/images/bg_gameplay.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Градієнт поверх фото (fade до кремового)
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0x55000000),
                  Color(0xFFFAF8F2),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar поверх фото
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left_rounded, size: 28, color: Colors.white),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CoinBadge(amount: player.coins),
                    ],
                  ),
                ),
                const SizedBox(height: 130),
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
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                      final unlocked = level != null &&
                          (index == 0 || player.starsFor(levels[index - 1].id) > 0);
                      final stars = level != null ? player.starsFor(level.id) : 0;
                      final isCurrentLevel =
                          unlocked && stars == 0 && (index == 0 || player.starsFor(levels[index - 1].id) > 0);
                      return LevelCell(
                        number: number,
                        stars: stars,
                        locked: !unlocked,
                        selected: isCurrentLevel,
                        onTap: level == null
                            ? null
                            : () => context.push('/category/$categoryId/level/${level.id}'),
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
