import 'package:supabase_flutter/supabase_flutter.dart';

import 'match_model.dart';

class RemoteMatchesRepository {
  static const _matchesTable = 'matches';
  static const _messagesTable = 'messages';

  Future<MatchModel?> getMatch(String matchId) async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) {
      return null;
    }

    final row = await client
        .from(_matchesTable)
        .select('id, user_a, user_b, unlocked_by_a, unlocked_by_b, unlocked_at')
        .eq('id', matchId)
        .maybeSingle();

    if (row == null) {
      return null;
    }

    return MatchModel.fromDatabaseRow(row, currentUserId: user.id);
  }

  Stream<MatchModel?> watchMatch(String matchId) {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return client
        .from(_matchesTable)
        .stream(primaryKey: ['id'])
        .eq('id', matchId)
        .map((rows) {
          if (rows.isEmpty) {
            return null;
          }
          return MatchModel.fromDatabaseRow(rows.first, currentUserId: user.id);
        });
  }

  Stream<({int myCount, int theirCount})> watchMessageCounts(String matchId) {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) {
      return Stream.value((myCount: 0, theirCount: 0));
    }

    return client
        .from(_messagesTable)
        .stream(primaryKey: ['id'])
        .eq('match_id', matchId)
        .map((rows) {
          var myCount = 0;
          var theirCount = 0;
          for (final row in rows) {
            final senderId = row['sender_id']?.toString();
            if (senderId == user.id) {
              myCount += 1;
            } else if (senderId != null && senderId.isNotEmpty) {
              theirCount += 1;
            }
          }
          return (myCount: myCount, theirCount: theirCount);
        });
  }

  Future<void> unlockMatch(String matchId) async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) {
      throw StateError('Cannot unlock match without an authenticated user.');
    }

    final row = await client
        .from(_matchesTable)
        .select('id, user_a, user_b, unlocked_by_a, unlocked_by_b, unlocked_at')
        .eq('id', matchId)
        .maybeSingle();
    if (row == null) {
      throw StateError('Match not found.');
    }

    final userA = row['user_a']?.toString();
    final userB = row['user_b']?.toString();
    if (user.id != userA && user.id != userB) {
      throw StateError('Current user is not a member of this match.');
    }

    final unlockedByA = row['unlocked_by_a'] == true;
    final unlockedByB = row['unlocked_by_b'] == true;

    final updates = <String, dynamic>{};

    if (user.id == userA && !unlockedByA) {
      updates['unlocked_by_a'] = true;
    }
    if (user.id == userB && !unlockedByB) {
      updates['unlocked_by_b'] = true;
    }

    final nextUnlockedByA = updates['unlocked_by_a'] == true || unlockedByA;
    final nextUnlockedByB = updates['unlocked_by_b'] == true || unlockedByB;
    if (nextUnlockedByA && nextUnlockedByB && row['unlocked_at'] == null) {
      updates['unlocked_at'] = DateTime.now().toUtc().toIso8601String();
    }

    if (updates.isEmpty) {
      return;
    }

    await client
        .from(_matchesTable)
        .update(updates)
        .eq('id', matchId)
        .or('user_a.eq.${user.id},user_b.eq.${user.id}');
  }
}
