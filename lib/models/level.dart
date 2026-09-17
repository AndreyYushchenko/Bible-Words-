enum WordDirection { horizontal, vertical }

/// One word placed in the level's crossword grid.
class PuzzleWord {
  const PuzzleWord({
    required this.answer,
    required this.row,
    required this.col,
    required this.direction,
  });

  final String answer;
  final int row;
  final int col;
  final WordDirection direction;

  /// Grid positions this word occupies, as (row, col) pairs, in letter order.
  List<(int, int)> cells() {
    return List.generate(answer.length, (i) {
      if (direction == WordDirection.horizontal) return (row, col + i);
      return (row + i, col);
    });
  }
}

class Level {
  const Level({
    required this.id,
    required this.categoryId,
    required this.number,
    required this.words,
    required this.wheelLetters,
    this.stars = 0,
    this.unlocked = false,
  });

  final String id;
  final String categoryId;
  final int number;
  final List<PuzzleWord> words;
  final List<String> wheelLetters;
  final int stars;
  final bool unlocked;

  int get rows =>
      words.map((w) => w.cells().map((c) => c.$1).reduce((a, b) => a > b ? a : b)).reduce((a, b) => a > b ? a : b) + 1;
  int get cols =>
      words.map((w) => w.cells().map((c) => c.$2).reduce((a, b) => a > b ? a : b)).reduce((a, b) => a > b ? a : b) + 1;

  Level copyWith({int? stars, bool? unlocked}) {
    return Level(
      id: id,
      categoryId: categoryId,
      number: number,
      words: words,
      wheelLetters: wheelLetters,
      stars: stars ?? this.stars,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
