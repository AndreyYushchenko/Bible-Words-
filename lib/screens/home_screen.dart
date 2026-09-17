import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/categories_data.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/category_row.dart';
import '../widgets/coin_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: const Color(0xFFE8DFC8), borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.castle_rounded, size: 22, color: Color(0xFF8B7A3E)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Привіт,', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      Text(
                        '${player.data.name} 👋',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
                CoinBadge(amount: player.coins, onAdd: () {}),
              ],
            ),
            const SizedBox(height: 20),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => context.push('/daily-challenge'),
                child: Ink(
                  height: 74,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(gradient: AppColors.tealGradient, borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    children: [
                      const Icon(Icons.eco_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Сьогодні нові можливості для відкритів',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13, height: 1.3),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Категорії', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            ...categories.map((cat) {
              final levels = levelsForCategory(cat.id);
              final done = levels.where((l) => player.starsFor(l.id) > 0).length;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CategoryRow(
                  category: cat,
                  progress: '$done/${cat.totalLevels}',
                  onTap: cat.unlocked ? () => context.push('/category/${cat.id}') : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
