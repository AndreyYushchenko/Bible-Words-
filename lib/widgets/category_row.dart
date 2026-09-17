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
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: locked ? null : AppColors.goldGradient,
                  color: locked ? AppColors.lockedBg : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(category.icon, size: 22, color: locked ? AppColors.lockedIcon : const Color(0xFF241408)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const SizedBox(height: 3),
                    Text(
                      locked ? 'Незабаром' : progress,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Icon(
                locked ? Icons.lock_rounded : Icons.chevron_right_rounded,
                size: locked ? 16 : 18,
                color: locked ? AppColors.lockedIcon : AppColors.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
