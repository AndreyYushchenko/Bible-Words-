import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'word_trail_painter.dart';

/// A ring of letter orbs you drag a finger across to trace a word (like
/// Words of Wonders): drag onto a new orb to add it, drag back onto the
/// previous orb to backtrack, lift to submit.
class LetterWheel extends StatelessWidget {
  const LetterWheel({
    super.key,
    required this.wheelKey,
    required this.letters,
    required this.selected,
    required this.dragPosition,
    required this.onLetterAdd,
    required this.onBacktrack,
    required this.onDragPositionChanged,
    required this.onSubmit,
    required this.onShuffle,
    required this.onClear,
    this.diameter = 250,
  });

  final GlobalKey wheelKey;
  final List<String> letters;
  final List<int> selected;

  /// Raw finger position (wheel-local), or null when not dragging.
  final Offset? dragPosition;

  final ValueChanged<int> onLetterAdd;
  final VoidCallback onBacktrack;
  final ValueChanged<Offset?> onDragPositionChanged;
  final VoidCallback onSubmit;
  final VoidCallback onShuffle;
  final VoidCallback onClear;
  final double diameter;

  double get _orbSize => letters.length <= 6 ? 58.0 : 50.0;

  /// Local (wheel-space) center of orb [index] — reused for hit-testing and
  /// for the flying-letter animation target computed in GameplayScreen.
  Offset orbCenter(int index) {
    final radius = diameter / 2 - _orbSize / 2 - 4;
    final center = diameter / 2;
    final angle = (-90 + index * (360 / letters.length)) * math.pi / 180;
    return Offset(center + radius * math.cos(angle), center + radius * math.sin(angle));
  }

  int? _orbAt(Offset local) {
    for (var i = 0; i < letters.length; i++) {
      if ((orbCenter(i) - local).distance <= _orbSize * 0.7) return i;
    }
    return null;
  }

  void _handlePosition(Offset local) {
    onDragPositionChanged(local);
    final hit = _orbAt(local);
    if (hit == null) return;
    if (selected.isNotEmpty && selected.last == hit) return;
    if (selected.length >= 2 && selected[selected.length - 2] == hit) {
      onBacktrack();
      return;
    }
    if (!selected.contains(hit)) {
      onLetterAdd(hit);
    }
  }

  Offset _toLocal(BuildContext context, Offset global) {
    final box = wheelKey.currentContext!.findRenderObject() as RenderBox;
    return box.globalToLocal(global);
  }

  @override
  Widget build(BuildContext context) {
    final trailPoints = [for (final i in selected) orbCenter(i), ?dragPosition];

    return GestureDetector(
      onPanStart: (d) => _handlePosition(_toLocal(context, d.globalPosition)),
      onPanUpdate: (d) => _handlePosition(_toLocal(context, d.globalPosition)),
      onPanEnd: (_) {
        onDragPositionChanged(null);
        onSubmit();
      },
      child: SizedBox(
        key: wheelKey,
        width: diameter,
        height: diameter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.28), shape: BoxShape.circle)),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: WordTrailPainter(points: trailPoints, color: AppColors.green)),
              ),
            ),
            Center(
              child: IgnorePointer(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                  child: const Icon(Icons.backspace_outlined, size: 20, color: Colors.white),
                ),
              ),
            ),
            for (var i = 0; i < letters.length; i++) _orb(i),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onShuffle,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
                  child: const Icon(Icons.shuffle_rounded, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orb(int i) {
    final c = orbCenter(i);
    final isSelected = selected.contains(i);

    return Positioned(
      left: c.dx - _orbSize / 2,
      top: c.dy - _orbSize / 2,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: isSelected ? _orbSize * 1.08 : _orbSize,
          height: isSelected ? _orbSize * 1.08 : _orbSize,
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.greenGradient : AppColors.goldGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isSelected ? const Color(0x403A9068) : const Color(0x40C08B28),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              letters[i],
              style: TextStyle(
                fontSize: _orbSize > 52 ? 22 : 19,
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
