import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();

    Widget row({required Widget leading, required String label, Widget? trailing}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            ?trailing,
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left_rounded), onPressed: () => context.pop()),
        title: const Text('Налаштування', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          row(
            leading: const Icon(Icons.volume_up_rounded, size: 18, color: AppColors.textMuted),
            label: 'Звуки',
            trailing: Switch(
              value: player.soundOn,
              activeThumbColor: AppColors.teal,
              onChanged: player.toggleSound,
            ),
          ),
          row(
            leading: const Icon(Icons.music_note_rounded, size: 18, color: AppColors.textMuted),
            label: 'Музика',
            trailing: Switch(
              value: player.musicOn,
              activeThumbColor: AppColors.teal,
              onChanged: player.toggleMusic,
            ),
          ),
          row(
            leading: const Icon(Icons.wb_sunny_rounded, size: 18, color: AppColors.textMuted),
            label: 'Тема',
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Світла', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFC9C4B4)),
              ],
            ),
          ),
          row(
            leading: const Icon(Icons.language_rounded, size: 18, color: AppColors.textMuted),
            label: 'Мова',
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Українська', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFC9C4B4)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          row(leading: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.textMuted), label: "Зворотній зв'язок", trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFC9C4B4))),
          row(leading: const Icon(Icons.star_border_rounded, size: 18, color: AppColors.textMuted), label: 'Оцінити додаток', trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFC9C4B4))),
          row(leading: const Icon(Icons.share_rounded, size: 18, color: AppColors.textMuted), label: 'Поділитися', trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFC9C4B4))),
          row(leading: const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textMuted), label: 'Про гру', trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFC9C4B4))),
        ],
      ),
    );
  }
}
