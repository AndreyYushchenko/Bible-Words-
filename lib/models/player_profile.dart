class PlayerProfileData {
  const PlayerProfileData({
    this.name = 'Андрій',
    this.coins = 285,
    this.streak = 3,
    this.wordsFound = 28,
    this.levelsCompleted = 12,
    this.soundOn = true,
    this.musicOn = true,
    this.levelStars = const {},
    this.dailyChallengeDone = const {},
  });

  final String name;
  final int coins;
  final int streak;
  final int wordsFound;
  final int levelsCompleted;
  final bool soundOn;
  final bool musicOn;

  /// levelId -> stars (1-3)
  final Map<String, int> levelStars;

  /// weekday index (1=Mon..7=Sun) -> completed today's challenge that day
  final Map<int, bool> dailyChallengeDone;

  PlayerProfileData copyWith({
    String? name,
    int? coins,
    int? streak,
    int? wordsFound,
    int? levelsCompleted,
    bool? soundOn,
    bool? musicOn,
    Map<String, int>? levelStars,
    Map<int, bool>? dailyChallengeDone,
  }) {
    return PlayerProfileData(
      name: name ?? this.name,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
      wordsFound: wordsFound ?? this.wordsFound,
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      soundOn: soundOn ?? this.soundOn,
      musicOn: musicOn ?? this.musicOn,
      levelStars: levelStars ?? this.levelStars,
      dailyChallengeDone: dailyChallengeDone ?? this.dailyChallengeDone,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'coins': coins,
        'streak': streak,
        'wordsFound': wordsFound,
        'levelsCompleted': levelsCompleted,
        'soundOn': soundOn,
        'musicOn': musicOn,
        'levelStars': levelStars,
        'dailyChallengeDone': dailyChallengeDone.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory PlayerProfileData.fromJson(Map<String, dynamic> json) {
    return PlayerProfileData(
      name: json['name'] as String? ?? 'Андрій',
      coins: json['coins'] as int? ?? 285,
      streak: json['streak'] as int? ?? 3,
      wordsFound: json['wordsFound'] as int? ?? 28,
      levelsCompleted: json['levelsCompleted'] as int? ?? 12,
      soundOn: json['soundOn'] as bool? ?? true,
      musicOn: json['musicOn'] as bool? ?? true,
      levelStars: (json['levelStars'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as int)) ?? const {},
      dailyChallengeDone: (json['dailyChallengeDone'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(int.parse(k), v as bool)) ??
          const {},
    );
  }
}
