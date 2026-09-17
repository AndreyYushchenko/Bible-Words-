import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/categories_data.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text('Статистика', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _statTile(
                  Icons.emoji_events_rounded,
                  '${player.data.levelsCompleted}',
                  'Пройдено\nрівнів',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statTile(
                  Icons.text_fields_rounded,
                  '${player.data.wordsFound}',
                  'Знайдено\nслів',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statTile(
                  Icons.local_fire_department_rounded,
                  '${player.data.streak}',
                  'Днів\nпоспіль',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Прогрес за категоріями',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 14),
          ...categories.map((cat) {
            final levels = levelsForCategory(cat.id);
            final done = levels.where((l) => player.starsFor(l.id) > 0).length;
            final ratio = cat.totalLevels == 0 ? 0.0 : done / cat.totalLevels;
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cat.name,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                      ),
                      Text(
                        '$done/${cat.totalLevels}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: AppColors.lockedBg,
                      valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statTile(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted, height: 1.3),
          ),
        ],
      ),
    );
  }
}
