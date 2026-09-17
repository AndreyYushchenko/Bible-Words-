import 'package:flutter/material.dart';
import '../models/achievement.dart';

final achievements = <Achievement>[
  Achievement(
    id: 'first-steps',
    icon: Icons.menu_book_rounded,
    title: 'Перші кроки',
    subtitle: 'Пройди 5 рівнів',
    target: 5,
    progressSelector: (s) => s.levelsCompleted,
  ),
  Achievement(
    id: 'names-lover',
    icon: Icons.school_rounded,
    title: 'Любитель імен',
    subtitle: 'Знайди 50 імен',
    target: 50,
    progressSelector: (s) => s.wordsFound,
  ),
  Achievement(
    id: 'truth-seeker',
    icon: Icons.emoji_events_rounded,
    title: 'Шукач істини',
    subtitle: 'Пройди 100 рівнів',
    target: 100,
    progressSelector: (s) => s.levelsCompleted,
  ),
  Achievement(
    id: 'scripture-master',
    icon: Icons.lock_rounded,
    title: 'Знавець Писання',
    subtitle: 'Пройди всі категорії',
    target: 6,
    progressSelector: (s) => s.categoriesCompleted,
  ),
  Achievement(
    id: 'word-master',
    icon: Icons.lock_rounded,
    title: 'Майстер слів',
    subtitle: 'Знайди 1000 слів',
    target: 1000,
    progressSelector: (s) => s.wordsFound,
  ),
];
