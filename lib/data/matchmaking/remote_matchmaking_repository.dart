import 'package:supabase_flutter/supabase_flutter.dart';

import '../profile/profile_repository_factory.dart';
import 'matchmaking_repository.dart';

class RemoteMatchmakingRepository implements MatchmakingRepository {
  static const _matchmakingQueueTable = 'matchmaking_queue';

  @override
  Future<void> setSearching({required bool active}) async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return;
    }

    final profile = await ProfileRepositoryFactory.create().loadProfile();
    if (profile == null) {
      return;
    }

    final genderPreference = profile.genderPreference.trim();
    final ageRangeMin = profile.ageRangeMin;
    final ageRangeMax = profile.ageRangeMax;

    await client.from(_matchmakingQueueTable).upsert(
      {
        'user_id': user.id,
        'gender_preference': genderPreference,
        'age_range_min': ageRangeMin,
        'age_range_max': ageRangeMax,
        'active': active,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'user_id',
    );
  }

  @override
  Future<String?> tryFindMatch() async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return null;
    }

    final result = await client.rpc('try_matchmake');
    if (result == null) {
      return null;
    }

    if (result is String && result.isNotEmpty) {
      return result;
    }

    return result.toString();
  }


  @override
  Future<String?> getLatestMyMatchId() async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return null;
    }

    final result = await client
        .from('matches')
        .select('id')
        .or('user_a.eq.${user.id},user_b.eq.${user.id}')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final matchId = result?['id'];
    if (matchId is String && matchId.isNotEmpty) {
      return matchId;
    }
    return null;
  }

  @override
  Future<String?> findBlindDateMatchId() async {
    await setSearching(active: true);
    return tryFindMatch();
  }
}
