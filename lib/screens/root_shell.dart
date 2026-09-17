import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'achievements_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    AchievementsScreen(),
    StatisticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: AppBottomNavBar(currentIndex: _index, onTap: (i) => setState(() => _index = i)),
    );
  }
}
