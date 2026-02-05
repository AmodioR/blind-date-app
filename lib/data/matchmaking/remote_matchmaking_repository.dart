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

    final rawCandidates = await client
        .from(_profilesTable)
        .select('id, age, gender')
        .order('updated_at', ascending: false)
        .limit(100);

    final existingMatches = await client
        .from(_matchesTable)
        .select('user_a, user_b')
        .or('user_a.eq.${user.id},user_b.eq.${user.id}');

    final matchedUserIds = <String>{};
    for (final match in existingMatches) {
      final userA = match['user_a']?.toString();
      final userB = match['user_b']?.toString();

      if (userA == null || userB == null) {
        continue;
      }

      if (userA == user.id) {
        matchedUserIds.add(userB);
      } else if (userB == user.id) {
        matchedUserIds.add(userA);
      }
    }

    String? candidateId;
    for (final candidate in rawCandidates) {
      final id = candidate['id']?.toString();
      final age = candidate['age'] as int?;
      final gender = candidate['gender']?.toString();

      if (id == null || id.isEmpty || id == user.id) {
        continue;
      }
      if (age == null || gender == null || gender.isEmpty) {
        continue;
      }
      if (age < ageRangeMin || age > ageRangeMax) {
        continue;
      }
      if (genderPreference != 'Alle' && gender != genderPreference) {
        continue;
      }
      if (matchedUserIds.contains(id)) {
        continue;
      }

      candidateId = id;
      break;
    }

    if (candidateId == null) {
      return null;
    }

    final inserted = await client
        .from(_matchesTable)
        .insert({'user_a': user.id, 'user_b': candidateId})
        .select('id')
        .single();

    return inserted['id']?.toString();
  }
}
