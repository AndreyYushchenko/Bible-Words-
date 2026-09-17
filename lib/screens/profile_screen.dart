import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    const target = 300;
    final progress = player.data.wordsFound + player.data.levelsCompleted * 5;
    final pct = (progress / target * 100).clamp(0, 100).round();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text('Профіль', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.settings_rounded, size: 22, color: AppColors.textMuted),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Аватар і ім'я
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColors.goldLight, width: 3),
                boxShadow: const [BoxShadow(color: Color(0x30000000), blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(38),
                child: Image.asset('assets/images/bg_splash.jpg', fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              player.data.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Шукай, і знайдеш 📖',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 20),

          // Загальний прогрес
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: pct / 100,
                        strokeWidth: 5,
                        backgroundColor: const Color(0xFFECE8DE),
                        valueColor: const AlwaysStoppedAnimation(AppColors.goldDark),
                      ),
                      Text(
                        '$pct%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Загальний прогрес',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$progress/$target',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Статистика 3 блоки
          Row(
            children: [
              Expanded(
                child: _stat(
                  Icons.local_fire_department_rounded,
                  '${player.data.streak}',
                  'Серія днів',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _stat(
                  Icons.bar_chart_rounded,
                  '${player.data.wordsFound}',
                  'Знайдено слів',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _stat(
                  Icons.emoji_events_rounded,
                  '${player.data.levelsCompleted}',
                  'Пройдено рівнів',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Меню
          _menuRow(context, Icons.emoji_events_rounded, 'Досягнення', () => context.push('/achievements')),
          _menuRow(context, Icons.settings_rounded, 'Налаштування', () => context.push('/settings')),
          _menuRow(context, Icons.info_outline_rounded, 'Про гру', () {}),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 18),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _menuRow(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFC0BDB0)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
