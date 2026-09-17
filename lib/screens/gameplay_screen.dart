import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/categories_data.dart';
import '../models/level.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/coin_badge.dart';
import '../widgets/crossword_grid.dart';
import '../widgets/letter_wheel.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key, required this.levelId});

  final String levelId;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late Level _level;
  late List<String> _wheelLetters;
  final List<int> _selected = [];
  final Set<String> _solved = {};
  int _hintsUsed = 0;

  @override
  void initState() {
    super.initState();
    _level = levelById(widget.levelId)!;
    _wheelLetters = List.of(_level.wheelLetters);
  }

  String get _attempt => _selected.map((i) => _wheelLetters[i]).join();

  List<String> get _remainingWords => _level.words
      .map((w) => w.answer)
      .where((a) => !_solved.contains(a))
      .toList();

  void _onLetterTap(int index) {
    if (_selected.contains(index)) return;
    setState(() => _selected.add(index));

    final attempt = _attempt;
    if (_remainingWords.contains(attempt)) {
      final player = context.read<PlayerProvider>();
      player.wordFound();
      player.addCoins(5);
      setState(() {
        _solved.add(attempt);
        _selected.clear();
      });
      if (_remainingWords.isEmpty) {
        _finishLevel();
      }
      return;
    }

    final longestRemaining = _remainingWords.map((w) => w.length).fold(0, max);
    if (attempt.length >= longestRemaining && longestRemaining > 0) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) setState(() => _selected.clear());
      });
    }
  }

  void _shuffle() {
    setState(() {
      _wheelLetters.shuffle(Random());
      _selected.clear();
    });
  }

  void _finishLevel() {
    final stars = _hintsUsed == 0 ? 3 : (_hintsUsed <= 2 ? 2 : 1);
    final player = context.read<PlayerProvider>();
    player.completeLevel(_level.id, stars);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.pushReplacement(
        '/category/${_level.categoryId}/level/${_level.id}/complete',
        extra: stars,
      );
    });
  }

  void _openHints() {
    final player = context.read<PlayerProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        Widget hintRow(
          IconData icon,
          String label,
          int cost,
          VoidCallback onUse,
        ) {
          return ListTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFD9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.goldDark),
            ),
            title: Text(label, style: const TextStyle(fontSize: 14)),
            trailing: Text(
              '-$cost',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              if (!player.spendCoins(cost)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Недостатньо монет')),
                );
                return;
              }
              onUse();
              Navigator.of(sheetContext).pop();
            },
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Підказки',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
              ),
              hintRow(
                Icons.lightbulb_outline_rounded,
                'Відкрити літеру',
                10,
                () {
                  final remaining = _remainingWords;
                  if (remaining.isEmpty) return;
                  setState(() {
                    _solved.add(remaining.first);
                    _hintsUsed++;
                    _selected.clear();
                  });
                  if (_remainingWords.isEmpty) _finishLevel();
                },
              ),
              hintRow(
                Icons.auto_fix_high_rounded,
                'Прибрати зайві літери',
                10,
                () {
                  setState(() => _hintsUsed++);
                },
              ),
              hintRow(Icons.remove_red_eye_outlined, 'Показати слово', 30, () {
                setState(() {
                  _solved.addAll(_remainingWords);
                  _hintsUsed += 3;
                  _selected.clear();
                });
                _finishLevel();
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final category = categoryById(_level.categoryId);

    return Scaffold(
      backgroundColor: const Color(0xFF2E2A24),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Рівень ${_level.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CoinBadge(amount: player.coins),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CrosswordGrid(level: _level, solvedWords: _solved),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _openHints,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Center(
                            child: Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppColors.goldDark,
                              size: 20,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.goldDark,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${_remainingWords.length}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LetterWheel(
                letters: _wheelLetters,
                selected: _selected,
                onLetterTap: _onLetterTap,
                onShuffle: _shuffle,
                onClear: () => setState(() => _selected.clear()),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
