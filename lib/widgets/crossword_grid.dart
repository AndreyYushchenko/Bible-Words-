import 'package:flutter/material.dart';
import '../models/level.dart';
import '../theme/app_theme.dart';

class CrosswordGrid extends StatelessWidget {
  const CrosswordGrid({super.key, required this.level, required this.solvedWords, this.cellSize = 40});

  final Level level;
  final Set<String> solvedWords;
  final double cellSize;

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
      mainAxisSize: MainAxisSize.min,
      children: List.generate(level.rows, (r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(level.cols, (c) {
              final pos = (r, c);
              final letter = letterAt[pos];
              final solved = solvedAt[pos] ?? false;
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
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              solved ? letter : '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF241408),
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
