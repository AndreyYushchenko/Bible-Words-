import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/categories_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

class LevelCompleteScreen extends StatelessWidget {
  const LevelCompleteScreen({super.key, required this.categoryId, required this.levelId, required this.stars});

  final String categoryId;
  final String levelId;
  final int stars;

  String? get _nextLevelId {
    final levels = levelsForCategory(categoryId);
    final index = levels.indexWhere((l) => l.id == levelId);
    if (index == -1 || index + 1 >= levels.length) return null;
    return levels[index + 1].id;
  }

  @override
  Widget build(BuildContext context) {
    final nextLevelId = _nextLevelId;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Реальне фото фону (пейзаж з руїнами)
          Image.asset(
            'assets/images/bg_landscape.jpg',
            fit: BoxFit.cover,
          ),
          // Легке накладення зверху для читабельності
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xBBFAF3E0),
                  Color(0x44FAF3E0),
                  Color(0x22FAF3E0),
                  Color(0x44FAF3E0),
                  Color(0xCCFAF3E0),
                ],
                stops: [0.0, 0.2, 0.5, 0.7, 1.0],
              ),
            ),
          ),
          // Контент
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Заголовок
                  Text(
                    'Рівень пройдено!',
                    style: AppTheme.display(size: 26, color: AppColors.textDark),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Зірки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final filled = i < stars;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star_rounded,
                          size: 46,
                          color: filled ? const Color(0xFFFFCC00) : Colors.white38,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Цитата — біла картка
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x20000000), blurRadius: 16, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '«Добрий подвиг я подвизав,\nвіру зберіг…»',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 15,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '2 Тимофія 4:7',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _chip(Icons.monetization_on_rounded, '+20'),
                            const SizedBox(width: 12),
                            _chip(Icons.bar_chart_rounded, '+1 рівень'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Кнопки
                  PrimaryButton(
                    label: 'Наступний рівень',
                    onPressed: () => context.go(
                      nextLevelId == null
                          ? '/category/$categoryId'
                          : '/category/$categoryId/level/$nextLevelId',
                    ),
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: 'До карти',
                    onPressed: () => context.go('/category/$categoryId'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x30C08B28), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF241408)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF241408), fontSize: 13)),
        ],
      ),
    );
  }
}
