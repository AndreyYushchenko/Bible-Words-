import 'package:flutter_test/flutter_test.dart';
import 'package:bible_words/data/categories_data.dart';

void main() {
  test('every level\'s crossword cells agree where words overlap', () {
    for (final level in namesLevels) {
      final letterAt = <(int, int), String>{};
      for (final word in level.words) {
        final cells = word.cells();
        for (var i = 0; i < cells.length; i++) {
          final pos = cells[i];
          final letter = word.answer[i];
          final existing = letterAt[pos];
          expect(
            existing == null || existing == letter,
            isTrue,
            reason: '${level.id}: "${word.answer}" wants $pos = $letter but it\'s already $existing',
          );
          letterAt[pos] = letter;
        }
      }
    }
  });

  test('every level\'s wheel has enough of each letter to spell every word', () {
    for (final level in namesLevels) {
      final wheelCounts = <String, int>{};
      for (final l in level.wheelLetters) {
        wheelCounts[l] = (wheelCounts[l] ?? 0) + 1;
      }
      for (final word in level.words) {
        final needed = <String, int>{};
        for (final ch in word.answer.split('')) {
          needed[ch] = (needed[ch] ?? 0) + 1;
        }
        needed.forEach((ch, count) {
          expect(
            (wheelCounts[ch] ?? 0) >= count,
            isTrue,
            reason: '${level.id}: "${word.answer}" needs $count of "$ch" but wheel only has ${wheelCounts[ch] ?? 0}',
          );
        });
      }
    }
  });

  test('bonus words never duplicate an actual crossword answer in the same level', () {
    for (final level in namesLevels) {
      final answers = level.words.map((w) => w.answer).toSet();
      for (final bonus in level.bonusWords) {
        expect(
          answers.contains(bonus),
          isFalse,
          reason: '${level.id}: bonus word "$bonus" is also one of the crossword answers',
        );
      }
    }
  });
}
