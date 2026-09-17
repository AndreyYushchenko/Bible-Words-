import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/achievements_screen.dart';
import 'screens/daily_challenge_screen.dart';
import 'screens/gameplay_screen.dart';
import 'screens/level_complete_screen.dart';
import 'screens/level_select_screen.dart';
import 'screens/root_shell.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const RootShell()),
    GoRoute(path: '/achievements', builder: (context, state) => const AchievementsScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/daily-challenge', builder: (context, state) => const DailyChallengeScreen()),
    GoRoute(
      path: '/category/:categoryId',
      builder: (context, state) => LevelSelectScreen(categoryId: state.pathParameters['categoryId']!),
      routes: [
        GoRoute(
          path: 'level/:levelId',
          builder: (context, state) => GameplayScreen(levelId: state.pathParameters['levelId']!),
          routes: [
            GoRoute(
              path: 'complete',
              builder: (context, state) => LevelCompleteScreen(
                categoryId: state.pathParameters['categoryId']!,
                stars: state.extra as int? ?? 3,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

class BibleWordsApp extends StatelessWidget {
  const BibleWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bible Words',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}
