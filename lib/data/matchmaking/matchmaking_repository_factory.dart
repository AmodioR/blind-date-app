import '../../config/app_config.dart';
import 'matchmaking_repository.dart';
import 'remote_matchmaking_repository.dart';

class MatchmakingRepositoryFactory {
  const MatchmakingRepositoryFactory._();

  static MatchmakingRepository create() {
    if (AppConfig.useRemoteMatchmaking) {
      return RemoteMatchmakingRepository();
    }
    return _DisabledMatchmakingRepository();
  }
}

class _DisabledMatchmakingRepository implements MatchmakingRepository {
  @override
  Future<void> setSearching({required bool active}) async {}

  @override
  Future<String?> tryFindMatch() async {
    return null;
  }

  @override
  Future<String?> getLatestMyMatchId() async {
    return null;
  }

  @override
  Future<String?> findBlindDateMatchId() async {
    return null;
  }
}
