import 'package:flutter/material.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';

class CrosswordGrid extends StatelessWidget {
  const CrosswordGrid({
    super.key,
    required this.gridKey,
    required this.level,
    required this.solvedWords,
    this.revealedCells = const {},
    this.cellSize = 42,
  });

  final GlobalKey gridKey;
  final Level level;
  final Set<String> solvedWords;

  /// Cells revealed one-at-a-time by the "Відкрити літеру" hint, for a word
  /// that isn't fully solved yet.
  final Set<(int, int)> revealedCells;
  final double cellSize;

  static const _gap = 4.0;

  /// Local (grid-space) center of cell (row, col) — used by GameplayScreen
  /// to compute the flying-letter animation's landing point.
  Offset cellCenter(int row, int col) {
    final step = cellSize + _gap;
    return Offset(col * step + cellSize / 2, row * step + cellSize / 2);
  }

  @override
  Widget build(BuildContext context) {
    final letterAt = <(int, int), String>{};
    final solvedAt = <(int, int), bool>{};

    for (final word in level.words) {
      final solved = solvedWords.contains(word.answer);
      final cells = word.cells();
      for (var i = 0; i < cells.length; i++) {
        final pos = cells[i];
        letterAt[pos] = word.answer[i];
        solvedAt[pos] = (solvedAt[pos] ?? false) || solved;
      }
    }

    return Column(
      key: gridKey,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(level.rows, (r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: _gap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(level.cols, (c) {
              final pos = (r, c);
              final letter = letterAt[pos];
              final solved = solvedAt[pos] ?? false;
              final revealed = !solved && revealedCells.contains(pos);
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: SizedBox(
                  width: cellSize,
                  height: cellSize,
                  child: letter == null
                      ? null
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: solved ? AppColors.goldGradient : null,
                            color: solved ? null : Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            border: solved
                                ? null
                                : Border.all(
                                    color: revealed ? AppColors.goldDark : const Color(0xFFE0DCD4),
                                    width: revealed ? 2 : 1,
                                  ),
                            boxShadow: solved
                                ? const [BoxShadow(color: Color(0x30C08B28), blurRadius: 6, offset: Offset(0, 2))]
                                : const [BoxShadow(color: Color(0x15000000), blurRadius: 3, offset: Offset(0, 1))],
                          ),
                          child: Center(
                            child: Text(
                              solved || revealed ? letter : '',
                              style: TextStyle(
                                fontSize: cellSize > 38 ? 17 : 14,
                                fontWeight: FontWeight.w700,
                                color: revealed ? AppColors.goldDark : const Color(0xFF241408),
                              ),
                            ),
                          ),
                        ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
