import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Реальне фото фону
          Image.asset(
            'assets/images/bg_splash.jpg',
            fit: BoxFit.cover,
          ),
          // Затемнення знизу для читабельності тексту
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0x99D4B882),
                  Color(0xEED4B882),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),
          // Контент
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 36),
              child: Column(
                children: [
                  // Лого — біла картка зверху
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(color: Color(0x30000000), blurRadius: 14, offset: Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.menu_book_rounded, size: 30, color: AppColors.textDark),
                    ),
                  ),
                  const Spacer(),
                  // Заголовок
                  Text(
                    'Bible',
                    style: AppTheme.display(size: 56, color: AppColors.textDark),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Words',
                    style: AppTheme.display(size: 56, color: AppColors.textDark),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Складай слова\nз Біблії',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: AppColors.textDark, height: 1.5),
                  ),
                  const Spacer(),
                  // Кнопка
                  PrimaryButton(label: 'Почати', onPressed: () => context.go('/home')),
                  const SizedBox(height: 16),
                  const Text(
                    'Ближче до Слова кожного дня',
                    style: TextStyle(fontSize: 13, color: AppColors.textDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
