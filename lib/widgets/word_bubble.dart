import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The live word-in-progress bubble above the letter wheel. Call
/// [WordBubbleState.shake] (via a [GlobalKey]) when a released word is
/// invalid or already found.
class WordBubble extends StatefulWidget {
  const WordBubble({super.key, required this.text});

  final String text;

  @override
  State<WordBubble> createState() => WordBubbleState();
}

class WordBubbleState extends State<WordBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  void shake() => _controller.forward(from: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dx = math.sin(_controller.value * math.pi * 6) * 8 * (1 - _controller.value);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: AnimatedOpacity(
        opacity: widget.text.isEmpty ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          constraints: const BoxConstraints(minWidth: 80, minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 3))],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark, letterSpacing: 2),
            ),
          ),
        ),
      ),
    );
  }
}
