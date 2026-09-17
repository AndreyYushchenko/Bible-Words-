import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/particle_burst.dart';

class LevelCompleteScreen extends StatefulWidget {
  const LevelCompleteScreen({super.key, required this.categoryId, required this.stars});

  final String categoryId;
  final int stars;

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _burst());
  }

  void _burst() {
    if (!mounted) return;
    final size = MediaQuery.sizeOf(context);
    final origin = Offset(size.width / 2, size.height * 0.28);
    for (var i = 0; i < widget.stars; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (!mounted) return;
        ParticleBurst.show(context, origin + Offset((i - 1) * 44, 0), color: AppColors.goldMid, count: 16);
      });
    }
  }

  String get categoryId => widget.categoryId;
  int get stars => widget.stars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Темний фон з градієнтом
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8D5A8),
                  Color(0xFFD4BA84),
                  Color(0xFFC4A870),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Фоновий пейзаж
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 300,
            child: CustomPaint(painter: _CompleteBgPainter()),
          ),
          // Контент
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),
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
                          size: 44,
                          color: filled ? AppColors.goldMid : Colors.white38,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Цитата
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '«Добрий подвиг я подвизав, віру зберіг…»',
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
                    onPressed: () => context.go('/category/$categoryId'),
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
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF241408)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF241408), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CompleteBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFFB89060).withOpacity(0.5);
    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.lineTo(size.width * 0.2, size.height * 0.1);
    path.lineTo(size.width * 0.4, size.height * 0.35);
    path.lineTo(size.width * 0.6, size.height * 0.05);
    path.lineTo(size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
