import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.totalLevels,
    required this.unlocked,
  });

  final String id;
  final String name;
  final IconData icon;
  final int totalLevels;
  final bool unlocked;
}
