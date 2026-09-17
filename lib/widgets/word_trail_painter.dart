import 'package:flutter/material.dart';

/// Draws the connecting trail between selected letter orbs, plus a live
/// segment out to the raw finger position while dragging. A soft blurred
/// under-stroke behind a bright core line gives it a warm glowing look
/// that matches the gold letter orbs instead of clashing with them.
class WordTrailPainter extends CustomPainter {
  const WordTrailPainter({required this.points, required this.color});

  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, glowPaint);

    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, corePaint);

    final dotPaint = Paint()..color = Colors.white;
    final dotGlow = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    for (final p in points) {
      canvas.drawCircle(p, 8, dotGlow);
      canvas.drawCircle(p, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WordTrailPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
