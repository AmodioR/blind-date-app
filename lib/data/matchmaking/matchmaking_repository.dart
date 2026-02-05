abstract class MatchmakingRepository {
  Future<void> setSearching({required bool active});

  Future<String?> tryFindMatch();

  Future<String?> findBlindDateMatchId();
}
