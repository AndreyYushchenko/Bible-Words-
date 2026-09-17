import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A ring of tappable letter orbs. Tapping a letter appends its index to
/// [selected]; the caller owns the selection state so it can validate words
/// as they're built up.
class LetterWheel extends StatelessWidget {
  const LetterWheel({
    super.key,
    required this.letters,
    required this.selected,
    required this.onLetterTap,
    required this.onShuffle,
    required this.onClear,
    this.diameter = 240,
  });

  final List<String> letters;
  final List<int> selected;
  final ValueChanged<int> onLetterTap;
  final VoidCallback onShuffle;
  final VoidCallback onClear;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final orbSize = letters.length <= 6 ? 56.0 : 48.0;
    final radius = diameter / 2 - orbSize / 2 - 4;
    final center = diameter / 2;

    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0x4D000000), shape: BoxShape.circle),
          ),
          Center(
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onClear,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Color(0x73000000), shape: BoxShape.circle),
                child: const Icon(Icons.backspace_outlined, size: 18, color: Colors.white),
              ),
            ),
          ),
          for (var i = 0; i < letters.length; i++) _orb(i, orbSize, radius, center),
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onShuffle,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: Color(0x73000000), shape: BoxShape.circle),
                child: const Icon(Icons.shuffle_rounded, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orb(int i, double orbSize, double radius, double center) {
    final angle = (-90 + i * (360 / letters.length)) * math.pi / 180;
    final x = center + radius * math.cos(angle) - orbSize / 2;
    final y = center + radius * math.sin(angle) - orbSize / 2;
    final isSelected = selected.contains(i);

    return Positioned(
      left: x,
      top: y,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onLetterTap(i),
        child: Container(
          width: orbSize,
          height: orbSize,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(colors: [Color(0xFF3FB893), Color(0xFF1F7A62)])
                : AppColors.goldGradient,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2))],
          ),
          child: Center(
            child: Text(
              letters[i],
              style: TextStyle(
                fontSize: orbSize > 50 ? 22 : 19,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF241408),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
