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
          // Фоновий градієнт (імітація пейзажу)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8D5B0),
                  Color(0xFFD4BA8A),
                  Color(0xFFC4A870),
                  Color(0xFFB89860),
                ],
                stops: [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          // Декоративні замки та пейзаж
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 260,
            child: CustomPaint(painter: _LandscapePainter()),
          ),
          // Контент
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 36),
              child: Column(
                children: [
                  // Лого
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x30000000), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: const Icon(Icons.menu_book_rounded, size: 32, color: AppColors.textDark),
                  ),
                  const Spacer(),
                  Text('Bible', style: AppTheme.display(size: 52, color: AppColors.textDark)),
                  Text('Words', style: AppTheme.display(size: 52, color: AppColors.textDark)),
                  const SizedBox(height: 14),
                  const Text(
                    'Складай слова\nз Біблії',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColors.textDark, height: 1.5),
                  ),
                  const Spacer(),
                  PrimaryButton(label: 'Почати', onPressed: () => context.go('/home')),
                  const SizedBox(height: 16),
                  const Text(
                    'Ближче до Слова кожного дня',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
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

class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Далекі гори
    paint.color = const Color(0xFFB8956A).withOpacity(0.5);
    final path1 = Path();
    path1.moveTo(0, size.height * 0.6);
    path1.lineTo(size.width * 0.15, size.height * 0.2);
    path1.lineTo(size.width * 0.3, size.height * 0.55);
    path1.lineTo(size.width * 0.5, size.height * 0.15);
    path1.lineTo(size.width * 0.7, size.height * 0.4);
    path1.lineTo(size.width * 0.85, size.height * 0.1);
    path1.lineTo(size.width, size.height * 0.35);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    // Ближні пагорби
    paint.color = const Color(0xFF9A7848).withOpacity(0.6);
    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.4, size.width * 0.5, size.height * 0.65);
    path2.quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width, size.height * 0.6);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint);

    // Замок зліва
    _drawCastle(canvas, Offset(size.width * 0.12, size.height * 0.5), 30, paint);

    // Замок справа (більший)
    _drawCastle(canvas, Offset(size.width * 0.78, size.height * 0.35), 45, paint);
  }

  void _drawCastle(Canvas canvas, Offset base, double scale, Paint paint) {
    paint.color = const Color(0xFF7A5C38).withOpacity(0.7);
    // Основа
    canvas.drawRect(Rect.fromLTWH(base.dx - scale * 0.5, base.dy - scale * 0.8, scale, scale * 0.8), paint);
    // Вежі
    canvas.drawRect(Rect.fromLTWH(base.dx - scale * 0.6, base.dy - scale * 1.2, scale * 0.3, scale * 0.5), paint);
    canvas.drawRect(Rect.fromLTWH(base.dx + scale * 0.3, base.dy - scale * 1.2, scale * 0.3, scale * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
