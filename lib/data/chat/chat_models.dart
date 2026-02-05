class ChatThread {
  final String id;
  final String displayName;
  final int displayAge;
  final bool isLocked;
  final double unlockProgress;
  final DateTime lastMessageAt;
  final String lastMessagePreview;
  final String? lastMessageSenderId;
  final bool isMyTurn;

  const ChatThread({
    required this.id,
    required this.displayName,
    required this.displayAge,
    required this.isLocked,
    required this.unlockProgress,
    required this.lastMessageAt,
    required this.lastMessagePreview,
    this.lastMessageSenderId,
    this.isMyTurn = false,
  });
}

class ChatMessage {
  static String currentUserId = 'local-user';

  final String id;
  final String matchId;
  final String senderId;
  final String body;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.body,
    required this.createdAt,
  });

  bool get isMe => senderId == currentUserId;
}
