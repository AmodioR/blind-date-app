import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'secret_chat_screen.dart';

class OpenChatsScreen extends StatelessWidget {
  const OpenChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatMessages = <String, List<String>>{
      'jonas-24': [
        'Godmorgen! Har du fået din kaffe endnu?',
        'Ja! Og jeg prøver en ny bønne i dag ☕️',
        'Nice, jeg er mere te-person. Hvad er dit go-to humørboost?',
      ],
      'magnus-22': [
        'Hvilken type musik får dig altid i godt humør?',
        'Indie pop eller noget med god energi. Dig?',
        'Jeg er 90’er rock hele vejen. Skal vi lave en playliste?',
      ],
      'oscar-25': [
        'Jeg tror vi ville være gode til at rejse sammen.',
        'Helt enig! Hvad er dit næste drømmerejsemål?',
        'Japan. Street food + neon. Hvordan med dig?',
      ],
      'sara-23': [
        'Hej! Jeg kan se vi begge elsker brunch.',
        'Det er mit yndlingsmåltid. Har du et favoritsted?',
        'Jeg har en lille café jeg elsker. Vil du have navnet?',
      ],
    };

    String? lastMessageFor(String chatId) {
      final messages = chatMessages[chatId];
      if (messages == null || messages.isEmpty) {
        return null;
      }

      final lastNonEmpty = messages.lastWhere(
        (message) => message.trim().isNotEmpty,
        orElse: () => '',
      );

      return lastNonEmpty.isEmpty ? null : lastNonEmpty;
    }

    // UI først: dummy chats
    final chats = <_ChatPreview>[
      _ChatPreview(
        id: 'jonas-24',
        name: 'Jonas',
        age: 24,
        lockState: _ChatLockState.locked,
        lastMessage: lastMessageFor('jonas-24'),
        time: '12:41',
        progress: 0.35,
        unread: 0,
      ),
      _ChatPreview(
        id: 'magnus-22',
        name: 'Magnus',
        age: 22,
        lockState: _ChatLockState.ready,
        lastMessage: lastMessageFor('magnus-22'),
        time: 'i går',
        progress: 0.92,
        unread: 2,
      ),
      _ChatPreview(
        id: 'oscar-25',
        name: 'Oscar',
        age: 25,
        lockState: _ChatLockState.locked,
        lastMessage: lastMessageFor('oscar-25'),
        time: 'man.',
        progress: 0.55,
        unread: 0,
      ),
      _ChatPreview(
        id: 'sara-23',
        name: 'Sara',
        age: 23,
        lockState: _ChatLockState.locked,
        lastMessage: lastMessageFor('sara-23'),
        time: 'søn.',
        progress: 0.2,
        unread: 0,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.premiumGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Lille intro (calm, app-like)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Dine blind dates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
              ),

              Expanded(
                child: chats.isEmpty
                    ? const _EmptyChatsState()
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: chats.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final chat = chats[i];
                          return _ChatCard(
                            chat: chat,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SecretChatScreen(chatId: chat.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------
// UI Components
// -------------------------

class _ChatCard extends StatelessWidget {
  final _ChatPreview chat;
  final VoidCallback onTap;

  const _ChatCard({
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = const Color(0xFFE6E0F2);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _Avatar(label: 'BD'),
                const SizedBox(width: 12),

                // Title + preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${chat.name}, ${chat.age}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            chat.time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        chat.lastMessage ?? 'Start en samtale',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusChip(status: chat.lockState),
                    if (chat.unread > 0) ...[
                      const SizedBox(height: 8),
                      _UnreadBadge(count: chat.unread),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: chat.uiProgress.clamp(0.0, 1.0),
                backgroundColor: Colors.black.withOpacity(0.06),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF6C4AB6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String label;
  const _Avatar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9D0F5)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xFF6C4AB6),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _ChatLockState status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isReady = status == _ChatLockState.ready;

    final bg = isReady ? const Color(0xFFE8FFF0) : const Color(0xFFF5F0FF);
    final fg = isReady ? const Color(0xFF16794C) : const Color(0xFF6C4AB6);
    final text = isReady ? 'Klar' : 'Låst';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;
  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6C4AB6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyChatsState extends StatelessWidget {
  const _EmptyChatsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E0F2)),
        ),
        child: const Text(
          'Ingen chats endnu.\nNår du matcher, dukker de op her 💬',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, height: 1.3),
        ),
      ),
    );
  }
}

// -------------------------
// Model (UI dummy)
// -------------------------

enum _ChatLockState { locked, ready }

class _ChatPreview {
  final String id;
  final String name;
  final int age;
  final _ChatLockState lockState;
  final String? lastMessage;
  final String time;
  final double progress;
  final int unread;

  _ChatPreview({
    required this.id,
    required this.name,
    required this.age,
    required this.lockState,
    required this.lastMessage,
    required this.time,
    required this.progress,
    required this.unread,
  });

  double get uiProgress => lockState == _ChatLockState.ready ? 1.0 : progress;
}
