import 'package:supabase_flutter/supabase_flutter.dart';

import 'chat_models.dart';
import 'chat_repository.dart';

class RemoteChatRepository implements ChatRepository {
  static const _matchesTable = 'matches';
  static const _messagesTable = 'messages';

  @override
  Future<List<ChatThread>> listThreads() async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return const [];
    }

    ChatMessage.currentUserId = user.id;

    final matches = await client
        .from(_matchesTable)
        .select('id, user_a, user_b')
        .or('user_a.eq.${user.id},user_b.eq.${user.id}');

    final threads = <ChatThread>[];

    for (final row in matches) {
      final matchId = row['id'].toString();
      final lastMessageRows = await client
          .from(_messagesTable)
          .select('id, body, created_at, sender_id')
          .eq('match_id', matchId)
          .order('created_at', ascending: false)
          .limit(1);

      final last = lastMessageRows.isEmpty ? null : lastMessageRows.first;
      final lastMessageAt = last == null
          ? DateTime.now()
          : DateTime.tryParse(last['created_at'] as String? ?? '') ?? DateTime.now();

      threads.add(
        ChatThread(
          id: matchId,
          displayName: 'Match',
          displayAge: 0,
          isLocked: true,
          unlockProgress: 0,
          lastMessageAt: lastMessageAt,
          lastMessagePreview: last?['body'] as String? ?? '',
        ),
      );
    }

    threads.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return threads;
  }

  @override
  Future<List<ChatMessage>> loadMessages(String matchId) async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return const [];
    }

    ChatMessage.currentUserId = user.id;

    final rows = await client
        .from(_messagesTable)
        .select('id, match_id, sender_id, body, created_at')
        .eq('match_id', matchId)
        .order('created_at', ascending: true);

    return rows
        .map(
          (row) => ChatMessage(
            id: row['id'].toString(),
            matchId: row['match_id'].toString(),
            senderId: row['sender_id'].toString(),
            body: row['body'] as String? ?? '',
            createdAt:
                DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now(),
          ),
        )
        .toList();
  }

  @override
  Future<void> sendMessage({required String matchId, required String body}) async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      throw StateError('Cannot send message without an authenticated user.');
    }

    final text = body.trim();
    if (text.isEmpty) {
      return;
    }

    ChatMessage.currentUserId = user.id;

    await client.from(_messagesTable).insert({
      'match_id': matchId,
      'sender_id': user.id,
      'body': text,
    });
  }
}
