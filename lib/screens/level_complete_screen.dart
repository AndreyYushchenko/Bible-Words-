import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

class LevelCompleteScreen extends StatelessWidget {
  const LevelCompleteScreen({super.key, required this.categoryId, required this.stars});

  final String categoryId;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2A24),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Рівень пройдено!',
                  style: AppTheme.display(size: 24, color: AppColors.goldLight), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final filled = i < stars;
                  return Icon(Icons.star_rounded, size: 36, color: filled ? AppColors.goldLight : Colors.white24);
                }),
              ),
              const SizedBox(height: 24),
              const Text(
                '«Добрий подвиг я подвизав, віру зберіг…»',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 6),
              const Text('2 Тимофія 4:7', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _chip(Icons.monetization_on_rounded, '+20'),
                  const SizedBox(width: 12),
                  _chip(Icons.bar_chart_rounded, '+1 рівень'),
                ],
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'До карти',
                icon: null,
                onPressed: () => context.go('/category/$categoryId'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.goldDark),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
        ],
      ),
    );
  }
}
