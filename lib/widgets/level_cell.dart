import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LevelCell extends StatelessWidget {
  const LevelCell({
    super.key,
    required this.number,
    required this.stars,
    required this.locked,
    required this.selected,
    this.onTap,
  });

  final int number;
  final int stars;
  final bool locked;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: locked ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: selected ? AppColors.goldGradient : null,
            color: selected ? null : (locked ? AppColors.lockedBg : AppColors.card),
            borderRadius: BorderRadius.circular(16),
            border: selected
                ? null
                : Border.all(color: locked ? Colors.transparent : AppColors.border),
            boxShadow: selected
                ? const [BoxShadow(color: Color(0x30C08B28), blurRadius: 8, offset: Offset(0, 3))]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFF241408)
                      : (locked ? AppColors.lockedIcon : AppColors.textDark),
                ),
              ),
              const SizedBox(height: 5),
              if (locked)
                const Icon(Icons.lock_rounded, size: 14, color: AppColors.lockedIcon)
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final filled = i < stars;
                    return Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: filled
                          ? (selected ? const Color(0xFF241408) : AppColors.gold)
                          : const Color(0xFFDDD9CF),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
