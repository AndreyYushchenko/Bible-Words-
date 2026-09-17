import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animates letter tiles flying from the wheel to their crossword cells,
/// via an [OverlayEntry] that removes itself when the flight finishes.
class FlyingLetters {
  FlyingLetters._();

  static void show(
    BuildContext context, {
    required List<String> letters,
    required List<Offset> starts,
    required List<Offset> ends,
    required VoidCallback onDone,
    Duration duration = const Duration(milliseconds: 450),
    Duration stagger = const Duration(milliseconds: 40),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null || letters.isEmpty) {
      onDone();
      return;
    }
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _FlyingLettersWidget(
        letters: letters,
        starts: starts,
        ends: ends,
        duration: duration,
        stagger: stagger,
        onDone: () {
          entry.remove();
          onDone();
        },
      ),
    );
    overlay.insert(entry);
  }
}

class _FlyingLettersWidget extends StatefulWidget {
  const _FlyingLettersWidget({
    required this.letters,
    required this.starts,
    required this.ends,
    required this.duration,
    required this.stagger,
    required this.onDone,
  });

  final List<String> letters;
  final List<Offset> starts;
  final List<Offset> ends;
  final Duration duration;
  final Duration stagger;
  final VoidCallback onDone;

  @override
  State<_FlyingLettersWidget> createState() => _FlyingLettersWidgetState();
}

class _FlyingLettersWidgetState extends State<_FlyingLettersWidget> with SingleTickerProviderStateMixin {
  late final int _n = widget.letters.length;
  late final Duration _total = Duration(
    milliseconds: widget.duration.inMilliseconds + widget.stagger.inMilliseconds * (_n - 1).clamp(0, 1000),
  );
  late final AnimationController _controller = AnimationController(vsync: this, duration: _total);

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

  Interval _intervalFor(int i) {
    final totalMs = _total.inMilliseconds;
    final beginMs = widget.stagger.inMilliseconds * i;
    final endMs = beginMs + widget.duration.inMilliseconds;
    return Interval((beginMs / totalMs).clamp(0.0, 1.0), (endMs / totalMs).clamp(0.0, 1.0), curve: Curves.easeOutBack);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: List.generate(_n, (i) {
              final t = _intervalFor(i).transform(_controller.value);
              final pos = Offset.lerp(widget.starts[i], widget.ends[i], t)!;
              return Positioned(
                left: pos.dx - 20,
                top: pos.dy - 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(6)),
                  child: Center(
                    child: Text(
                      widget.letters[i],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF241408)),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
