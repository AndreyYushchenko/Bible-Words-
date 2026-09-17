import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/level.dart';

/// Builds a crossword out of one vertical "spine" word plus any number of
/// horizontal words that each cross it at one shared letter. Each crosser is
/// `(word, spineIndex, wordIndex)`: the letter at `word[wordIndex]` must equal
/// `spine[spineIndex]` — that's the one thing to get right by hand, the row/
/// column placement and the wheel's letter counts (including a letter that
/// appears twice in one word, like the two Д in ДАВИД) are derived from it.
Level _buildLevel({
  required String id,
  required int number,
  required String spine,
  List<(String word, int spineIndex, int wordIndex)> crossers = const [],
  List<String> bonusWords = const [],
}) {
  final spineCol = crossers.isEmpty ? 0 : crossers.map((c) => c.$3).reduce((a, b) => a > b ? a : b);
  final words = <PuzzleWord>[
    PuzzleWord(answer: spine, row: 0, col: spineCol, direction: WordDirection.vertical),
    for (final c in crossers)
      PuzzleWord(answer: c.$1, row: c.$2, col: spineCol - c.$3, direction: WordDirection.horizontal),
  ];

  final letterCounts = <String, int>{};
  for (final word in [spine, ...crossers.map((c) => c.$1)]) {
    final counts = <String, int>{};
    for (final ch in word.split('')) {
      counts[ch] = (counts[ch] ?? 0) + 1;
    }
    counts.forEach((ch, count) {
      if (count > (letterCounts[ch] ?? 0)) letterCounts[ch] = count;
    });
  }
  final wheelLetters = <String>[for (final entry in letterCounts.entries) for (var i = 0; i < entry.value; i++) entry.key];

  return Level(
    id: id,
    categoryId: 'names',
    number: number,
    unlocked: false,
    words: words,
    wheelLetters: wheelLetters,
    bonusWords: bonusWords,
  );
}

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

/// All 50 levels for "Імена людей", each a spine word (a Bible name) plus
/// 0-2 crossers, via `_buildLevel`. Levels still unlock in order — only the
/// first is unlocked by default, later ones open as earlier ones get stars.
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
  Level(
    id: 'names-4',
    categoryId: 'names',
    number: 4,
    unlocked: false,
    words: const [
      PuzzleWord(answer: 'ГАД', row: 0, col: 1, direction: WordDirection.vertical),
      PuzzleWord(answer: 'ДАН', row: 1, col: 0, direction: WordDirection.horizontal),
    ],
    wheelLetters: const ['Г', 'А', 'Д', 'Н'],
    bonusWords: const ['НАД'],
  ),
  Level(
    id: 'names-5',
    categoryId: 'names',
    number: 5,
    unlocked: false,
    words: const [
      PuzzleWord(answer: 'ЛІЯ', row: 0, col: 1, direction: WordDirection.vertical),
      PuzzleWord(answer: 'ІСАК', row: 1, col: 1, direction: WordDirection.horizontal),
    ],
    wheelLetters: const ['Л', 'І', 'Я', 'С', 'А', 'К'],
    bonusWords: const ['ЛАК'],
  ),
  Level(
    id: 'names-6',
    categoryId: 'names',
    number: 6,
    unlocked: false,
    words: const [
      PuzzleWord(answer: 'ЯКІВ', row: 0, col: 2, direction: WordDirection.vertical),
      PuzzleWord(answer: 'ЛІЯ', row: 2, col: 1, direction: WordDirection.horizontal),
    ],
    wheelLetters: const ['Я', 'К', 'І', 'В', 'Л'],
    bonusWords: const ['ВІЛ'],
  ),
  Level(
    id: 'names-7',
    categoryId: 'names',
    number: 7,
    unlocked: false,
    words: const [
      PuzzleWord(answer: 'АСИР', row: 0, col: 1, direction: WordDirection.vertical),
      PuzzleWord(answer: 'ІСАК', row: 1, col: 0, direction: WordDirection.horizontal),
    ],
    wheelLetters: const ['А', 'С', 'И', 'Р', 'І', 'К'],
    bonusWords: const ['РИС'],
  ),
  _buildLevel(
    id: 'names-8',
    number: 8,
    spine: 'ЙОСИП',
    crossers: const [('САУЛ', 2, 0)],
  ),
  _buildLevel(
    id: 'names-9',
    number: 9,
    spine: 'РУВИМ',
    crossers: const [('ВІЛ', 2, 0), ('СУД', 1, 1)],
    bonusWords: const ['ЛІС'],
  ),
  _buildLevel(
    id: 'names-10',
    number: 10,
    spine: 'СИМЕОН',
    crossers: const [('ОСА', 4, 0), ('СОМ', 0, 0)],
  ),
  _buildLevel(
    id: 'names-11',
    number: 11,
    spine: 'ЛЕВІЙ',
    crossers: const [('ЛІС', 0, 0), ('ВІЛ', 2, 0)],
    bonusWords: const ['ЛЕВ'],
  ),
  _buildLevel(
    id: 'names-12',
    number: 12,
    spine: 'ЗАВУЛОН',
    crossers: const [('САД', 1, 1), ('СУД', 3, 1)],
    bonusWords: const ['ЗАЛ'],
  ),
  _buildLevel(
    id: 'names-13',
    number: 13,
    spine: 'ІСАЯ',
    crossers: const [('САД', 1, 0), ('МАК', 2, 1)],
    bonusWords: const ['ДІМ'],
  ),
  _buildLevel(
    id: 'names-14',
    number: 14,
    spine: 'ІЛЛЯ',
    crossers: const [('ЛІС', 1, 0)],
  ),
  _buildLevel(
    id: 'names-15',
    number: 15,
    spine: 'ЛУКА',
    crossers: const [('МАК', 3, 1)],
    bonusWords: const ['МУЛ'],
  ),
  _buildLevel(
    id: 'names-16',
    number: 16,
    spine: 'МАРКО',
    crossers: const [('РАЙ', 2, 0)],
    bonusWords: const ['РАК'],
  ),
  _buildLevel(
    id: 'names-17',
    number: 17,
    spine: 'ХОМА',
    crossers: const [('МАК', 2, 0)],
  ),
  _buildLevel(id: 'names-18', number: 18, spine: 'АДАМ', crossers: const [('ДІМ', 1, 0)]),
  _buildLevel(id: 'names-19', number: 19, spine: 'КАЇН', crossers: const [('МАК', 1, 1)]),
  _buildLevel(id: 'names-20', number: 20, spine: 'АВЕЛЬ', crossers: const [('ВІЛ', 1, 0)]),
  _buildLevel(id: 'names-21', number: 21, spine: 'СИМ', crossers: const [('САД', 0, 0)]),
  _buildLevel(id: 'names-22', number: 22, spine: 'ХАМ', crossers: const [('МАК', 1, 1)]),
  _buildLevel(id: 'names-23', number: 23, spine: 'ЯФЕТ'),
  _buildLevel(id: 'names-24', number: 24, spine: 'АВРААМ', crossers: const [('РАЙ', 2, 0)]),
  _buildLevel(id: 'names-25', number: 25, spine: 'САРА', crossers: const [('РАЙ', 2, 0)]),
  _buildLevel(id: 'names-26', number: 26, spine: 'ІСАВ', crossers: const [('САД', 1, 0)]),
  _buildLevel(id: 'names-27', number: 27, spine: 'РАХІЛЬ', crossers: const [('ЛІС', 4, 0)]),
  _buildLevel(id: 'names-28', number: 28, spine: 'ЮДА', crossers: const [('ДІМ', 1, 0)]),
  _buildLevel(
    id: 'names-29',
    number: 29,
    spine: 'НЕФТАЛИМ',
    crossers: const [('ЛІС', 5, 0), ('МАК', 4, 1)],
  ),
  _buildLevel(id: 'names-30', number: 30, spine: 'ІССАХАР', crossers: const [('РАЙ', 6, 0)]),
  _buildLevel(
    id: 'names-31',
    number: 31,
    spine: 'ААРОН',
    crossers: const [('РАЙ', 2, 0), ('СОМ', 3, 1)],
  ),
  _buildLevel(id: 'names-32', number: 32, spine: 'МІРІАМ', crossers: const [('РАЙ', 2, 0)]),
  _buildLevel(
    id: 'names-33',
    number: 33,
    spine: 'ЙОВ',
    crossers: const [('СОМ', 1, 1), ('ВІЛ', 2, 0)],
  ),
  _buildLevel(
    id: 'names-34',
    number: 34,
    spine: 'ГЕДЕОН',
    crossers: const [('ДІМ', 2, 0), ('СОМ', 4, 1)],
  ),
  _buildLevel(
    id: 'names-35',
    number: 35,
    spine: 'САМСОН',
    crossers: const [('САД', 0, 0), ('СОМ', 4, 1)],
  ),
  _buildLevel(id: 'names-36', number: 36, spine: 'РУТ', crossers: const [('РАЙ', 0, 0)]),
  _buildLevel(id: 'names-37', number: 37, spine: 'НОЕМІ', crossers: const [('СОМ', 1, 1)]),
  _buildLevel(
    id: 'names-38',
    number: 38,
    spine: 'САМУЇЛ',
    crossers: const [('ЛІС', 5, 0), ('САД', 0, 0)],
  ),
  _buildLevel(
    id: 'names-39',
    number: 39,
    spine: 'СОЛОМОН',
    crossers: const [('ЛІС', 2, 0), ('СОМ', 4, 2)],
  ),
  _buildLevel(id: 'names-40', number: 40, spine: 'ЙОНА', crossers: const [('СОМ', 1, 1)]),
  _buildLevel(
    id: 'names-41',
    number: 41,
    spine: 'ЄЛИСЕЙ',
    crossers: const [('ЛІС', 1, 0), ('САД', 3, 0)],
  ),
  _buildLevel(
    id: 'names-42',
    number: 42,
    spine: 'ДАНІЇЛ',
    crossers: const [('ДІМ', 0, 0), ('ЛІС', 5, 0)],
  ),
  _buildLevel(
    id: 'names-43',
    number: 43,
    spine: 'ІЄРЕМІЯ',
    crossers: const [('РАЙ', 2, 0), ('СОМ', 4, 2)],
  ),
  _buildLevel(id: 'names-44', number: 44, spine: 'ІСУС', crossers: const [('САД', 1, 0)]),
  _buildLevel(
    id: 'names-45',
    number: 45,
    spine: 'МАРІЯ',
    crossers: const [('РАЙ', 2, 0), ('МАК', 1, 1)],
  ),
  _buildLevel(
    id: 'names-46',
    number: 46,
    spine: 'ПЕТРО',
    crossers: const [('РАЙ', 3, 0), ('СОМ', 4, 1)],
  ),
  _buildLevel(
    id: 'names-47',
    number: 47,
    spine: 'ПАВЛО',
    crossers: const [('ВІЛ', 2, 0), ('ЛІС', 3, 0)],
  ),
  _buildLevel(id: 'names-48', number: 48, spine: 'ІВАН', crossers: const [('ВІЛ', 1, 0)]),
  _buildLevel(
    id: 'names-49',
    number: 49,
    spine: 'АНДРІЙ',
    crossers: const [('ДІМ', 2, 0), ('РАЙ', 3, 0)],
  ),
  _buildLevel(id: 'names-50', number: 50, spine: 'ПИЛИП', crossers: const [('ЛІС', 2, 0)]),
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
