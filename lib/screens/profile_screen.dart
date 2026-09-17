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
      appBar: AppBar(title: const Text('Профіль', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: const Color(0xFFE8DFC8), borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.castle_rounded, size: 30, color: Color(0xFF8B7A3E)),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text(player.data.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
          const SizedBox(height: 4),
          const Center(child: Text('Шукай, і знайдеш 📖', style: TextStyle(fontSize: 13, color: AppColors.textMuted))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: pct / 100,
                        strokeWidth: 5,
                        backgroundColor: const Color(0xFFE8DFC8),
                        valueColor: const AlwaysStoppedAnimation(AppColors.goldDark),
                      ),
                      Text('$pct%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.goldDark)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Загальний прогрес', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('$progress/$target', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _stat(Icons.local_fire_department_rounded, '${player.data.streak} дні', 'Серія')),
              const SizedBox(width: 12),
              Expanded(child: _stat(Icons.text_fields_rounded, '${player.data.wordsFound}', 'Знайдено слів')),
              const SizedBox(width: 12),
              Expanded(child: _stat(Icons.star_rounded, '${player.data.levelsCompleted}', 'Пройдено рівнів')),
            ],
          ),
          const SizedBox(height: 20),
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
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 18),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
                const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFC9C4B4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
