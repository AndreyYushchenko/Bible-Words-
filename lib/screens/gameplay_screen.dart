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
import '../widgets/flying_letters.dart';
import '../widgets/letter_wheel.dart';
import '../widgets/particle_burst.dart';
import '../services/sound_service.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key, required this.levelId});

  final String levelId;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> with SingleTickerProviderStateMixin {
  late Level _level;
  late List<String> _wheelLetters;
  final List<int> _selected = [];
  final Set<String> _solved = {};
  final Set<String> _bonusFound = {};
  int _hintsUsed = 0;
  Offset? _dragPosition;
  bool _flying = false;

  final GlobalKey _wheelKey = GlobalKey();
  final GlobalKey _gridKey = GlobalKey();
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    _level = levelById(widget.levelId)!;
    _wheelLetters = List.of(_level.wheelLetters);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  String get _attempt => _selected.map((i) => _wheelLetters[i]).join();

  List<String> get _remainingWords => _level.words
      .map((w) => w.answer)
      .where((a) => !_solved.contains(a))
      .toList();

  void _onLetterAdd(int index) {
    SoundService.tap();
    setState(() => _selected.add(index));
  }

  void _onBacktrack() => setState(() => _selected.removeLast());

  void _onDragPositionChanged(Offset? pos) =>
      setState(() => _dragPosition = pos);

  Offset _wheelGlobalOrigin() =>
      (_wheelKey.currentContext!.findRenderObject() as RenderBox).localToGlobal(
        Offset.zero,
      );

  Offset _gridGlobalOrigin() =>
      (_gridKey.currentContext!.findRenderObject() as RenderBox).localToGlobal(
        Offset.zero,
      );

  void _onSubmit() {
    if (_flying || _selected.isEmpty) {
      setState(_selected.clear);
      return;
    }
    final attempt = _attempt;
    final indices = List<int>.from(_selected);

    if (_remainingWords.contains(attempt)) {
      _flyToGrid(attempt, indices);
      return;
    }

    if (_level.bonusWords.contains(attempt) && !_bonusFound.contains(attempt)) {
      SoundService.wordFound();
      final player = context.read<PlayerProvider>();
      player.addCoins(3);
      setState(() {
        _bonusFound.add(attempt);
        _selected.clear();
      });
      final origin = _wheelGlobalOrigin();
      ParticleBurst.show(
        context,
        origin + Offset(125, 20),
        color: AppColors.green,
        count: 8,
      );
      return;
    }

    SoundService.error();
    _shakeController.forward(from: 0);
    setState(_selected.clear);
  }

  void _flyToGrid(String answer, List<int> indices) {
    final word = _level.words.firstWhere((w) => w.answer == answer);
    final wheelOrigin = _wheelGlobalOrigin();
    final gridOrigin = _gridGlobalOrigin();

    final wheel = LetterWheel(
      wheelKey: _wheelKey,
      letters: _wheelLetters,
      selected: const [],
      dragPosition: null,
      onLetterAdd: (_) {},
      onBacktrack: () {},
      onDragPositionChanged: (_) {},
      onSubmit: () {},
      onShuffle: () {},
    );
    final grid = CrosswordGrid(
      gridKey: _gridKey,
      level: _level,
      solvedWords: _solved,
    );

    final starts = indices
        .map((i) => wheelOrigin + wheel.orbCenter(i))
        .toList();
    final ends = word
        .cells()
        .map((c) => gridOrigin + grid.cellCenter(c.$1, c.$2))
        .toList();

    setState(() {
      _flying = true;
      _selected.clear();
    });

    FlyingLetters.show(
      context,
      letters: answer.split(''),
      starts: starts,
      ends: ends,
      onDone: () {
        if (!mounted) return;
        SoundService.wordFound();
        final player = context.read<PlayerProvider>();
        player.wordFound();
        player.addCoins(5);
        setState(() {
          _solved.add(answer);
          _flying = false;
        });
        ParticleBurst.show(
          context,
          ends[ends.length ~/ 2],
          color: AppColors.gold,
        );
        if (_remainingWords.isEmpty) _finishLevel();
      },
    );
  }

  void _shuffle() {
    setState(() {
      _wheelLetters.shuffle(Random());
      _selected.clear();
    });
  }

  void _finishLevel() {
    SoundService.levelComplete();
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 4,
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFD9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.goldDark),
            ),
            title: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (r) => AppColors.goldGradient.createShader(r),
                  child: const Icon(
                    Icons.monetization_on_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '-$cost',
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
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
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.lockedIcon,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 4),
              // Watch ad row
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.goldLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_circle_outline_rounded,
                    size: 20,
                    color: AppColors.goldDark,
                  ),
                ),
                title: const Text(
                  'Дивись відео',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (r) =>
                          AppColors.goldGradient.createShader(r),
                      child: const Icon(
                        Icons.monetization_on_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'і отримай 50 монет',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.pop(sheetContext),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openDictionary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Словник', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(sheetContext),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Цікаві слова, які ти склав із цих літер',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _bonusFound
                    .map(
                      (w) => Chip(
                        label: Text(w, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        backgroundColor: Colors.white,
                        avatar: const Icon(Icons.star_rounded, size: 16, color: AppColors.goldDark),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    String? badge,
  }) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: disabled ? Colors.white.withValues(alpha: 0.5) : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: disabled ? AppColors.lockedIcon : AppColors.goldDark, size: 22),
              ),
              if (badge != null)
                Positioned(
                  right: -3,
                  top: -3,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(color: AppColors.goldDark, shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        badge,
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final category = categoryById(_level.categoryId);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Реальне фото фону
          Image.asset(
            'assets/images/bg_gameplay.jpg',
            fit: BoxFit.cover,
          ),
          // Темне накладення для читабельності
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC1E1408),
                  Color(0x991E1408),
                  Color(0xDD1E1408),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Рівень ${_level.number}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                category.name,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CoinBadge(amount: player.coins),
                        const SizedBox(width: 4),
                        // Налаштування / шестерня
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.settings_rounded,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Кросворд
                  CrosswordGrid(
                    gridKey: _gridKey,
                    level: _level,
                    solvedWords: _solved,
                    cellSize: 46,
                  ),

                  const SizedBox(height: 20),

                  // Колесо літер
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final t = _shakeController.value;
                      final dx = sin(t * pi * 6) * 10 * (1 - t);
                      return Transform.translate(offset: Offset(dx, 0), child: child);
                    },
                    child: LetterWheel(
                      wheelKey: _wheelKey,
                      letters: _wheelLetters,
                      selected: _selected,
                      dragPosition: _dragPosition,
                      onLetterAdd: _onLetterAdd,
                      onBacktrack: _onBacktrack,
                      onDragPositionChanged: _onDragPositionChanged,
                      onSubmit: _onSubmit,
                      onShuffle: _shuffle,
                      diameter: 280,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Підказка + Словник знайдених бонусних слів
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _bottomActionButton(
                        icon: Icons.lightbulb_outline_rounded,
                        label: 'Підказка',
                        badge: '${_remainingWords.length}',
                        onTap: _openHints,
                      ),
                      const SizedBox(width: 16),
                      _bottomActionButton(
                        icon: Icons.menu_book_rounded,
                        label: 'Словник',
                        badge: _bonusFound.isEmpty ? null : '${_bonusFound.length}',
                        onTap: _bonusFound.isEmpty ? null : _openDictionary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD4B070);

    // Колони
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.1 + i * 0.2);
      canvas.drawRect(
        Rect.fromLTWH(x, size.height * 0.3, 8, size.height * 0.7),
        paint,
      );
      canvas.drawRect(Rect.fromLTWH(x - 4, size.height * 0.25, 16, 6), paint);
    }

    // Горизонт
    paint.color = const Color(0xFFC4A060);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
