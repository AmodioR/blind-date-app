import 'chat_models.dart';

abstract class ChatRepository {
  Future<List<ChatThread>> listThreads();
  Future<List<ChatMessage>> loadMessages(String matchId);
  Future<void> sendMessage({required String matchId, required String body});
}
