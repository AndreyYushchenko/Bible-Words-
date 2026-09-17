import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.menu_book_rounded, size: 28, color: AppColors.textDark),
              ),
              const Spacer(),
              Text('Bible', style: AppTheme.display(size: 48), textAlign: TextAlign.center),
              Text('Words', style: AppTheme.display(size: 48), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text(
                'Складай слова\nз Біблії',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textDark),
              ),
              const Spacer(),
              PrimaryButton(label: 'Почати', onPressed: () => context.go('/home')),
              const SizedBox(height: 14),
              const Text(
                'Ближче до Слова кожного дня',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
