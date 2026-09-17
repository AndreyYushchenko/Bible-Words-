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

    Widget iconBox(IconData icon) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.lockedBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 17, color: AppColors.textMuted),
      );
    }

    Widget row({
      required IconData leadingIcon,
      required String label,
      Widget? trailing,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            iconBox(leadingIcon),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            ?trailing,
          ],
        ),
      );
    }

    Widget arrowRow({required IconData leadingIcon, required String label, String? subtitle}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            iconBox(leadingIcon),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            if (subtitle != null)
              Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFC0BDB0)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text('Налаштування', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          row(
            leadingIcon: Icons.volume_up_rounded,
            label: 'Звуки',
            trailing: Switch(
              value: player.soundOn,
              onChanged: player.toggleSound,
            ),
          ),
          arrowRow(
            leadingIcon: Icons.wb_sunny_rounded,
            label: 'Тема',
            subtitle: 'Світла ☀',
          ),
          arrowRow(
            leadingIcon: Icons.language_rounded,
            label: 'Мова',
            subtitle: 'Українська',
          ),
          const SizedBox(height: 8),
          arrowRow(leadingIcon: Icons.chat_bubble_outline_rounded, label: "Зворотній зв'язок"),
          arrowRow(leadingIcon: Icons.star_border_rounded, label: 'Оцінити додаток'),
          arrowRow(leadingIcon: Icons.share_rounded, label: 'Поділитися'),
          arrowRow(leadingIcon: Icons.info_outline_rounded, label: 'Про гру'),
        ],
      ),
    );
  }
}
