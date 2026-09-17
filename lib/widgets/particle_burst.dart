import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A small hand-rolled radial particle burst, shown once via an
/// [OverlayEntry] that removes itself when the animation finishes.
class ParticleBurst {
  ParticleBurst._();

  static void show(BuildContext context, Offset center, {Color color = AppColors.gold, int count = 14}) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _BurstWidget(center: center, color: color, count: count, onDone: () => entry.remove()),
    );
    overlay.insert(entry);
  }
}

class _BurstWidget extends StatefulWidget {
  const _BurstWidget({required this.center, required this.color, required this.count, required this.onDone});

  final Offset center;
  final Color color;
  final int count;
  final VoidCallback onDone;

  @override
  State<_BurstWidget> createState() => _BurstWidgetState();
}

class _BurstWidgetState extends State<_BurstWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );
  final _random = math.Random();
  late final List<double> _angles = List.generate(widget.count, (i) => (i / widget.count) * 2 * math.pi + _random.nextDouble() * 0.4);
  late final List<double> _lengths = List.generate(widget.count, (_) => 36 + _random.nextDouble() * 30);

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onDone();
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _BurstPainter(
              progress: _controller.value,
              center: widget.center,
              angles: _angles,
              lengths: _lengths,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter({required this.progress, required this.center, required this.angles, required this.lengths, required this.color});

  final double progress;
  final Offset center;
  final List<double> angles;
  final List<double> lengths;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final eased = Curves.easeOut.transform(progress);
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < angles.length; i++) {
      final dist = lengths[i] * eased;
      final pos = center + Offset(math.cos(angles[i]), math.sin(angles[i])) * dist;
      final opacity = (1 - progress).clamp(0.0, 1.0);
      paint.color = (i.isEven ? color : AppColors.teal).withValues(alpha: opacity);
      canvas.drawCircle(pos, 4 * (1 - progress * 0.6), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) => oldDelegate.progress != progress;
}
