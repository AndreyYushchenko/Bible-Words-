import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key, required this.category, required this.progress, required this.onTap});

  final Category category;
  final String progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locked = !category.unlocked;
    final images = [
      'assets/images/bg_splash.jpg',
      'assets/images/bg_gameplay.jpg',
      'assets/images/bg_landscape.jpg',
    ];
    final bgImage = images[category.name.length % images.length];

    return Container(
      height: 72,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Фото фон
                Image.asset(
                  bgImage,
                  fit: BoxFit.cover,
                  color: locked ? Colors.grey : null,
                  colorBlendMode: locked ? BlendMode.saturation : null,
                ),
                // Темне накладення
                Container(
                  color: locked ? const Color(0xD91E1A14) : const Color(0x991E1A14),
                ),
                // Контент
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      // Іконка
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: locked ? null : AppColors.goldGradient,
                          color: locked ? Colors.white.withOpacity(0.1) : null,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          category.icon,
                          size: 22,
                          color: locked ? Colors.white54 : const Color(0xFF241408),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: locked ? Colors.white60 : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              locked ? 'Незабаром' : progress,
                              style: TextStyle(
                                fontSize: 13,
                                color: locked ? Colors.white38 : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        locked ? Icons.lock_rounded : Icons.chevron_right_rounded,
                        size: locked ? 16 : 22,
                        color: locked ? Colors.white38 : Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
