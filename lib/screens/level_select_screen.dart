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
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left_rounded), onPressed: () => context.pop()),
        title: Text(category.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16), child: Center(child: CoinBadge(amount: player.coins))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${category.totalLevels} рівнів', style: AppTheme.display(size: 24)),
            const SizedBox(height: 10),
            const Text(
              '«Пізнавайте Його через імена, які змінили історію»',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
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
                  return LevelCell(
                    number: number,
                    stars: stars,
                    locked: !unlocked,
                    selected: unlocked && stars == 0 && index == 0,
                    onTap: level == null ? null : () => context.push('/category/$categoryId/level/${level.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
