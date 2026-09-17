import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/level.dart';

const namesCategory = Category(
  id: 'names',
  name: 'Імена людей',
  icon: Icons.people_alt_rounded,
  totalLevels: 50,
  unlocked: true,
);

final categories = <Category>[
  namesCategory,
  const Category(id: 'places', name: 'Місця', icon: Icons.location_on_rounded, totalLevels: 50, unlocked: false),
  const Category(id: 'events', name: 'Події', icon: Icons.watch_later_rounded, totalLevels: 50, unlocked: false),
  const Category(id: 'books', name: 'Книги Біблії', icon: Icons.menu_book_rounded, totalLevels: 50, unlocked: false),
  const Category(id: 'objects', name: 'Предмети', icon: Icons.local_florist_rounded, totalLevels: 50, unlocked: false),
  const Category(id: 'words', name: 'Біблійні слова', icon: Icons.auto_awesome_rounded, totalLevels: 50, unlocked: false),
];

/// The 3 real, playable levels for "Імена людей". Everything else in that
/// category is shown locked in the level-select grid.
final List<Level> namesLevels = [
  Level(
    id: 'names-1',
    categoryId: 'names',
    number: 1,
    unlocked: true,
    words: const [
      PuzzleWord(answer: 'ДАВИД', row: 0, col: 2, direction: WordDirection.vertical),
      PuzzleWord(answer: 'САУЛ', row: 1, col: 1, direction: WordDirection.horizontal),
    ],
    // ДАВИД needs two "Д" tiles (first and last letter) — one wasn't enough to spell it.
    wheelLetters: const ['Д', 'А', 'В', 'И', 'С', 'У', 'Л', 'Д'],
    bonusWords: const ['САД', 'ВАЛ', 'УДАВ'],
  ),
  Level(
    id: 'names-2',
    categoryId: 'names',
    number: 2,
    unlocked: false,
    words: const [
      PuzzleWord(answer: 'НОЙ', row: 0, col: 1, direction: WordDirection.vertical),
      PuzzleWord(answer: 'ЛОТ', row: 1, col: 0, direction: WordDirection.horizontal),
    ],
    wheelLetters: const ['Н', 'О', 'Й', 'Л', 'Т'],
    bonusWords: const ['ТОН'],
  ),
  Level(
    id: 'names-3',
    categoryId: 'names',
    number: 3,
    unlocked: false,
    words: const [
      PuzzleWord(answer: 'ЛЕВ', row: 0, col: 1, direction: WordDirection.vertical),
      PuzzleWord(answer: 'ЄВА', row: 2, col: 0, direction: WordDirection.horizontal),
    ],
    wheelLetters: const ['Л', 'Е', 'В', 'Є', 'А'],
    bonusWords: const ['АЛЕ'],
  ),
];

Category categoryById(String id) => categories.firstWhere((c) => c.id == id);

List<Level> levelsForCategory(String categoryId) {
  if (categoryId == 'names') return namesLevels;
  return const [];
}

Level? levelById(String id) {
  for (final l in namesLevels) {
    if (l.id == id) return l;
  }
  return null;
}
