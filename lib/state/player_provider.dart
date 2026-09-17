import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_profile.dart';
import '../services/sound_service.dart';
import '../services/music_service.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerProvider() {
    _load();
  }

  static const _prefsKey = 'player_profile_v1';

  PlayerProfileData _data = const PlayerProfileData();
  PlayerProfileData get data => _data;

  int get coins => _data.coins;
  int get streak => _data.streak;
  bool get soundOn => _data.soundOn;
  bool get musicOn => _data.musicOn;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      try {
        _data = PlayerProfileData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        notifyListeners();
      } catch (_) {
        // Ignore corrupt local data and keep defaults.
      }
    }
    SoundService.enabled = _data.soundOn;
    MusicService.enabled = _data.musicOn;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_data.toJson()));
  }

  void _update(PlayerProfileData Function(PlayerProfileData) fn) {
    _data = fn(_data);
    notifyListeners();
    _save();
  }

  bool spendCoins(int amount) {
    if (_data.coins < amount) return false;
    _update((d) => d.copyWith(coins: d.coins - amount));
    return true;
  }

  void addCoins(int amount) {
    _update((d) => d.copyWith(coins: d.coins + amount));
  }

  void wordFound() {
    _update((d) => d.copyWith(wordsFound: d.wordsFound + 1));
  }

  int starsFor(String levelId) => _data.levelStars[levelId] ?? 0;

  void completeLevel(String levelId, int stars, {int reward = 20}) {
    _update((d) {
      final current = d.levelStars[levelId] ?? 0;
      final next = Map<String, int>.from(d.levelStars);
      if (stars > current) next[levelId] = stars;
      return d.copyWith(
        coins: d.coins + reward,
        levelsCompleted: current == 0 ? d.levelsCompleted + 1 : d.levelsCompleted,
        levelStars: next,
      );
    });
  }

  bool isDailyChallengeDoneToday() {
    final weekday = DateTime.now().weekday;
    return _data.dailyChallengeDone[weekday] ?? false;
  }

  void completeDailyChallenge() {
    final weekday = DateTime.now().weekday;
    _update((d) {
      final next = Map<int, bool>.from(d.dailyChallengeDone)..[weekday] = true;
      return d.copyWith(dailyChallengeDone: next, streak: d.streak + 1);
    });
  }

  void toggleSound(bool value) {
    SoundService.enabled = value;
    _update((d) => d.copyWith(soundOn: value));
  }
  
  void toggleMusic(bool value) {
    MusicService.enabled = value;
    _update((d) => d.copyWith(musicOn: value));
  }
}
