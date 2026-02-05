import 'chat_models.dart';
import 'chat_repository.dart';

class LocalChatRepository implements ChatRepository {
  static const _localUserId = 'local-user';

  static final Map<String, _LocalChatData> _chatConversations = {
    'jonas-24': _LocalChatData(
      name: 'Jonas',
      age: 24,
      messages: [
        _SeedMessage(body: 'Godmorgen! Har du fået din kaffe endnu?', isMe: false),
        _SeedMessage(body: 'Ja! Og jeg prøver en ny bønne i dag ☕️', isMe: true),
        _SeedMessage(
            body: 'Nice, jeg er mere te-person. Hvad er dit go-to humørboost?',
            isMe: false),
      ],
    ),
    'magnus-22': _LocalChatData(
      name: 'Magnus',
      age: 22,
      messages: [
        _SeedMessage(body: 'Godmorgen, sovet godt?', isMe: false),
        _SeedMessage(body: 'Ja, helt roligt i nat.', isMe: true),
        _SeedMessage(body: 'Hvad skal din dag?', isMe: false),
        _SeedMessage(body: 'Arbejde og lidt træning.', isMe: true),
        _SeedMessage(body: 'Lyder fint. Hvilken træning?', isMe: false),
        _SeedMessage(body: 'En kort løbetur.', isMe: true),
        _SeedMessage(body: 'Jeg går en tur senere.', isMe: false),
        _SeedMessage(body: 'Det gør godt.', isMe: true),
        _SeedMessage(body: 'Har du frokostplaner?', isMe: false),
        _SeedMessage(body: 'Salat og kaffe.', isMe: true),
        _SeedMessage(body: 'Kaffe er altid godt.', isMe: false),
        _SeedMessage(body: 'Helt enig.', isMe: true),
        _SeedMessage(body: 'Hvilken musik nu?', isMe: false),
        _SeedMessage(body: 'Rolig indie i dag.', isMe: true),
        _SeedMessage(body: 'Det passer til vejret.', isMe: false),
        _SeedMessage(body: 'Ja, det gør.', isMe: true),
        _SeedMessage(body: 'Skal vi lave playlisten?', isMe: false),
        _SeedMessage(body: 'Gerne, send dine favoritter.', isMe: true),
        _SeedMessage(body: 'Jeg sender et par.', isMe: false),
        _SeedMessage(body: 'Fedt, jeg glæder mig.', isMe: true),
      ],
    ),
    'oscar-25': _LocalChatData(
      name: 'Oscar',
      age: 25,
      messages: [
        _SeedMessage(body: 'Jeg tror vi ville være gode til at rejse sammen.', isMe: false),
        _SeedMessage(body: 'Helt enig! Hvad er dit næste drømmerejsemål?', isMe: true),
        _SeedMessage(body: 'Japan. Street food + neon. Hvordan med dig?', isMe: false),
      ],
    ),
    'sara-23': _LocalChatData(
      name: 'Sara',
      age: 23,
      messages: [
        _SeedMessage(body: 'Hej! Jeg kan se vi begge elsker brunch.', isMe: false),
        _SeedMessage(body: 'Det er mit yndlingsmåltid. Har du et favoritsted?', isMe: true),
        _SeedMessage(body: 'Jeg har en lille café jeg elsker. Vil du have navnet?', isMe: false),
      ],
    ),
  };

  static final Map<String, List<ChatMessage>> _messagesByMatch =
      _buildInitialMessages();

  static Map<String, List<ChatMessage>> _buildInitialMessages() {
    final now = DateTime.now();
    final result = <String, List<ChatMessage>>{};

    for (final entry in _chatConversations.entries) {
      final seeded = <ChatMessage>[];
      for (var i = 0; i < entry.value.messages.length; i++) {
        final seed = entry.value.messages[i];
        seeded.add(
          ChatMessage(
            id: '${entry.key}-$i',
            matchId: entry.key,
            senderId: seed.isMe ? _localUserId : 'match-${entry.key}',
            body: seed.body,
            createdAt: now.subtract(Duration(minutes: entry.value.messages.length - i)),
          ),
        );
      }
      result[entry.key] = seeded;
    }

    return result;
  }

  @override
  Future<List<ChatThread>> listThreads() async {
    ChatMessage.currentUserId = _localUserId;

    return _chatConversations.entries.map((entry) {
      final messages = _messagesByMatch[entry.key] ?? const <ChatMessage>[];
      final last = messages.isEmpty
          ? ChatMessage(
              id: '${entry.key}-empty',
              matchId: entry.key,
              senderId: _localUserId,
              body: '',
              createdAt: DateTime.now(),
            )
          : messages.last;

      final myCount = messages.where((message) => message.isMe).length;
      final theirCount = messages.length - myCount;
      final progress = (myCount < theirCount ? myCount : theirCount) / 10;

      return ChatThread(
        id: entry.key,
        displayName: entry.value.name,
        displayAge: entry.value.age,
        isLocked: !(myCount >= 10 && theirCount >= 10),
        unlockProgress: progress.clamp(0.0, 1.0),
        lastMessageAt: last.createdAt,
        lastMessagePreview: last.body,
      );
    }).toList();
  }

  @override
  Future<List<ChatMessage>> loadMessages(String matchId) async {
    ChatMessage.currentUserId = _localUserId;

    final messages = _messagesByMatch[matchId];
    if (messages == null) {
      return const [];
    }

    return List<ChatMessage>.from(messages);
  }

  @override
  Future<void> sendMessage({required String matchId, required String body}) async {
    final messageText = body.trim();
    if (messageText.isEmpty) {
      return;
    }

    final messages = _messagesByMatch.putIfAbsent(matchId, () => []);
    messages.add(
      ChatMessage(
        id: '$matchId-local-${DateTime.now().microsecondsSinceEpoch}',
        matchId: matchId,
        senderId: _localUserId,
        body: messageText,
        createdAt: DateTime.now(),
      ),
    );
  }

  static ChatThread? findThread(String matchId) {
    final seed = _chatConversations[matchId];
    if (seed == null) {
      return null;
    }
    final messages = _messagesByMatch[matchId] ?? const <ChatMessage>[];
    final last = messages.isNotEmpty ? messages.last : null;
    return ChatThread(
      id: matchId,
      displayName: seed.name,
      displayAge: seed.age,
      isLocked: true,
      unlockProgress: 0,
      lastMessageAt: last?.createdAt ?? DateTime.now(),
      lastMessagePreview: last?.body ?? '',
    );
  }
}

class _LocalChatData {
  final String name;
  final int age;
  final List<_SeedMessage> messages;

  const _LocalChatData({
    required this.name,
    required this.age,
    required this.messages,
  });
}

class _SeedMessage {
  final String body;
  final bool isMe;

  const _SeedMessage({required this.body, required this.isMe});
}
