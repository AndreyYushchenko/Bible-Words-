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
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          onPressed: () => context.pop(),
        ),
        title: const Text('Щоденний виклик', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // Іконка виклику
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(color: Color(0x20000000), blurRadius: 20, offset: Offset(0, 6)),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Center(
                          child: Icon(Icons.description_rounded, size: 44, color: AppColors.goldDark),
                        ),
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8623C),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.local_fire_department_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Знайди 5 слів сьогодні',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 24),

                  // Дні тижня
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(7, (i) {
                      final weekday = i + 1;
                      final isDone = weekday < today || (weekday == today && done);
                      final isToday = weekday == today;
                      return Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppColors.green
                                  : isToday
                                      ? AppColors.goldLight.withValues(alpha: 0.4)
                                      : AppColors.lockedBg,
                              shape: BoxShape.circle,
                              border: isToday && !isDone
                                  ? Border.all(color: AppColors.goldMid, width: 2)
                                  : null,
                            ),
                            child: isDone
                                ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _labels[i],
                            style: TextStyle(
                              fontSize: 11,
                              color: isToday ? AppColors.goldDark : AppColors.textMuted,
                              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 28),

                  // Кнопка
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      label: done ? 'Виконано сьогодні ✓' : 'Почати',
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
                  ),
                ],
              ),
            ),
          ),

          // Фото пейзажу знизу з цитатою поверх
          SizedBox(
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/bg_landscape.jpg', fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xDDFAF8F2), Color(0x88000000)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Мале вірне сьогодні\nприводить до великого завтра',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
