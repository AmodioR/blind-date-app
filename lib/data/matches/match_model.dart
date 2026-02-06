class MatchModel {
  final String id;
  final String userA;
  final String userB;
  final bool unlockedByMe;
  final bool unlockedByOther;
  final DateTime? unlockedAt;
  final int myCount;
  final int theirCount;

  const MatchModel({
    required this.id,
    required this.userA,
    required this.userB,
    required this.unlockedByMe,
    required this.unlockedByOther,
    required this.unlockedAt,
    this.myCount = 0,
    this.theirCount = 0,
  });

  double get unlockProgress {
    final minimumCount = myCount < theirCount ? myCount : theirCount;
    return (minimumCount / 10).clamp(0.0, 1.0).toDouble();
  }

  bool get isFullyUnlocked => unlockedAt != null || (unlockedByMe && unlockedByOther);

  factory MatchModel.fromDatabaseRow(
    Map<String, dynamic> row, {
    required String currentUserId,
    int myCount = 0,
    int theirCount = 0,
  }) {
    final userA = row['user_a']?.toString() ?? '';
    final userB = row['user_b']?.toString() ?? '';
    final unlockedByA = row['unlocked_by_a'] == true;
    final unlockedByB = row['unlocked_by_b'] == true;

    final isUserA = currentUserId == userA;

    return MatchModel(
      id: row['id'].toString(),
      userA: userA,
      userB: userB,
      unlockedByMe: isUserA ? unlockedByA : unlockedByB,
      unlockedByOther: isUserA ? unlockedByB : unlockedByA,
      unlockedAt: DateTime.tryParse(row['unlocked_at'] as String? ?? ''),
      myCount: myCount,
      theirCount: theirCount,
    );
  }

  MatchModel copyWith({
    int? myCount,
    int? theirCount,
  }) {
    return MatchModel(
      id: id,
      userA: userA,
      userB: userB,
      unlockedByMe: unlockedByMe,
      unlockedByOther: unlockedByOther,
      unlockedAt: unlockedAt,
      myCount: myCount ?? this.myCount,
      theirCount: theirCount ?? this.theirCount,
    );
  }
}
