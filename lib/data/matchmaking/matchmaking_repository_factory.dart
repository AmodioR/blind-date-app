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
  Future<String?> findBlindDateMatchId() async {
    return null;
  }
}
