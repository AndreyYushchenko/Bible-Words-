import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  static const _labels = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Нд'];

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final today = DateTime.now().weekday;
    final done = player.isDailyChallengeDoneToday();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left_rounded), onPressed: () => context.pop()),
        title: const Text('Щоденний виклик', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 16, offset: Offset(0, 4))],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(child: Icon(Icons.description_rounded, size: 40, color: AppColors.goldDark)),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(color: Color(0xFFE8623C), shape: BoxShape.circle),
                      child: const Icon(Icons.local_fire_department_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Знайди 5 слів сьогодні', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (i) {
                final weekday = i + 1;
                final isDone = weekday < today || (weekday == today && done);
                return Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.teal : AppColors.lockedBg,
                        shape: BoxShape.circle,
                      ),
                      child: isDone ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                    ),
                    const SizedBox(height: 8),
                    Text(_labels[i], style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                );
              }),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: done ? 'Виконано сьогодні' : 'Почати',
              icon: null,
              onPressed: done
                  ? null
                  : () {
                      player.completeDailyChallenge();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Щоденний виклик виконано! +10 монет')),
                      );
                      player.addCoins(10);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
