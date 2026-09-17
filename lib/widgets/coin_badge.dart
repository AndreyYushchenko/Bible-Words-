import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CoinBadge extends StatelessWidget {
  const CoinBadge({super.key, required this.amount, this.onAdd});

  final int amount;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (r) => AppColors.goldGradient.createShader(r),
                child: const Icon(Icons.monetization_on_rounded, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Text(
                '$amount',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        if (onAdd != null) ...[
          const SizedBox(width: 6),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(17),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.textDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}
