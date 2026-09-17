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
    this.disabled = const {},
    this.diameter = 250,
  });

  final GlobalKey wheelKey;
  final List<String> letters;
  final List<int> selected;

  /// Orb indices grayed out and untappable by the "Прибрати зайві літери" hint.
  final Set<int> disabled;

  /// Raw finger position (wheel-local), or null when not dragging.
  final Offset? dragPosition;

  final ValueChanged<int> onLetterAdd;
  final VoidCallback onBacktrack;
  final ValueChanged<Offset?> onDragPositionChanged;
  final VoidCallback onSubmit;
  final VoidCallback onShuffle;
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
      if (disabled.contains(i)) continue;
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
                child: CustomPaint(painter: WordTrailPainter(points: trailPoints, color: AppColors.goldMid)),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: onShuffle,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                  child: const Icon(Icons.shuffle_rounded, size: 22, color: Colors.white),
                ),
              ),
            ),
            for (var i = 0; i < letters.length; i++) _orb(i),
          ],
        ),
      ),
    );
  }

  Widget _orb(int i) {
    final c = orbCenter(i);
    final isSelected = selected.contains(i);
    final isDisabled = disabled.contains(i);

    return Positioned(
      left: c.dx - _orbSize / 2,
      top: c.dy - _orbSize / 2,
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDisabled ? 0.25 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            width: isSelected ? _orbSize * 1.12 : _orbSize,
            height: isSelected ? _orbSize * 1.12 : _orbSize,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(colors: [Color(0xFFFFF3D6), Color(0xFFF0C878)])
                  : AppColors.goldGradient,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
              boxShadow: [
                BoxShadow(
                  color: isSelected ? const Color(0x80F0C878) : const Color(0x40C08B28),
                  blurRadius: isSelected ? 16 : 8,
                  spreadRadius: isSelected ? 1 : 0,
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
                  color: const Color(0xFF241408),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
