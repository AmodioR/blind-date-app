import 'package:supabase_flutter/supabase_flutter.dart';

import '../profile/profile_repository_factory.dart';
import 'matchmaking_repository.dart';

class RemoteMatchmakingRepository implements MatchmakingRepository {
  static const _profilesTable = 'profiles';
  static const _matchesTable = 'matches';

  @override
  Future<String?> findBlindDateMatchId() async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return null;
    }

    final profile = await ProfileRepositoryFactory.create().loadProfile();
    if (profile == null) {
      return null;
    }

    final ageRangeMin = profile.ageRangeMin;
    final ageRangeMax = profile.ageRangeMax;
    final genderPreference = profile.genderPreference.trim();
    if (ageRangeMin <= 0 || ageRangeMax <= 0 || genderPreference.isEmpty) {
      return null;
    }

    var candidateQuery = client
        .from(_profilesTable)
        .select('id, gender, age')
        .neq('id', user.id)
        .not('gender', 'is', null)
        .not('age', 'is', null)
        .gte('age', ageRangeMin)
        .lte('age', ageRangeMax)
        .order('updated_at', ascending: false)
        .limit(20);

    if (genderPreference != 'Alle') {
      candidateQuery = candidateQuery.filter('gender', 'eq', genderPreference);
    }

    final candidates = await candidateQuery;

    for (final candidate in candidates) {
      final candidateId = candidate['id']?.toString();
      if (candidateId == null || candidateId.isEmpty) {
        continue;
      }

      final existingMatches = await client
          .from(_matchesTable)
          .select('id')
          .or(
            'and(user_a.eq.${user.id},user_b.eq.$candidateId),'
            'and(user_b.eq.${user.id},user_a.eq.$candidateId)',
          )
          .limit(1);

      if (existingMatches.isNotEmpty) {
        continue;
      }

      final inserted = await client
          .from(_matchesTable)
          .insert({'user_a': user.id, 'user_b': candidateId})
          .select('id')
          .single();

      return inserted['id']?.toString();
    }

    return null;
  }
}
