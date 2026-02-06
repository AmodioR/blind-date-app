import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../config/supabase_config.dart';
import '../data/chat/chat_models.dart';
import '../data/chat/chat_repository_factory.dart';
import '../theme/app_colors.dart';
import 'secret_chat_screen.dart';

class OpenChatsScreen extends StatefulWidget {
  const OpenChatsScreen({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  State<OpenChatsScreen> createState() => _OpenChatsScreenState();
}

class _OpenChatsScreenState extends State<OpenChatsScreen> {
  final _repository = ChatRepositoryFactory.create();
  late Future<List<_ChatPreview>> _chatsFuture;
  RealtimeChannel? _messagesChannel;

  @override
  void initState() {
    super.initState();
    _refreshChats();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    if (_messagesChannel != null) {
      Supabase.instance.client.removeChannel(_messagesChannel!);
      _messagesChannel = null;
    }
    super.dispose();
  }

  void _refreshChats() {
    _chatsFuture = _loadChats();
    if (mounted) {
      setState(() {});
    }
  }

  void _subscribeToMessages() {
    if (!AppConfig.useRemoteChat || !SupabaseConfig.isConfigured || _messagesChannel != null) {
      return;
    }

    final client = Supabase.instance.client;
    ChatMessage.currentUserId = widget.currentUserId;

    _messagesChannel = client
        .channel('open-chats:messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (_) {
            if (!mounted) {
              return;
            }
            _refreshChats();
          },
        )
        .subscribe();
  }

  Future<List<_ChatPreview>> _loadChats() async {
    final threads = await _repository.listThreads();
    final chats = <_ChatPreview>[];

    for (final thread in threads) {
      String? lastMessage;
      bool isUsersTurn = false;

      if (AppConfig.useRemoteChat) {
        isUsersTurn = thread.isMyTurn;
        lastMessage = thread.lastMessagePreview.trim().isEmpty ? null : thread.lastMessagePreview;
      } else {
        final messages = await _repository.loadMessages(thread.id);
        final hasMessages = messages.isNotEmpty;
        isUsersTurn = hasMessages ? !messages.last.isMe : false;
        lastMessage = thread.lastMessagePreview.trim().isEmpty
            ? (hasMessages ? messages.last.body : null)
            : thread.lastMessagePreview;
      }

      chats.add(
        _ChatPreview(
          id: thread.id,
          name: thread.displayName,
          age: thread.displayAge,
          lockState: thread.isLocked ? _ChatLockState.locked : _ChatLockState.ready,
          lastMessage: lastMessage,
          time: _timeLabelFor(thread),
          progress: thread.unlockProgress,
          isUsersTurn: isUsersTurn,
        ),
      );
    }

    return chats;
  }

  String _timeLabelFor(ChatThread thread) {
    const localDemoLabels = {
      'jonas-24': '12:41',
      'magnus-22': 'i går',
      'oscar-25': 'man.',
      'sara-23': 'søn.',
    };
    if (!AppConfig.useRemoteChat && localDemoLabels.containsKey(thread.id)) {
      return localDemoLabels[thread.id]!;
    }

    final now = DateTime.now();
    final date = thread.lastMessageAt;
    final isSameDay = now.year == date.year && now.month == date.month && now.day == date.day;
    if (isSameDay) {
      final hours = date.hour.toString().padLeft(2, '0');
      final minutes = date.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == date.year &&
        yesterday.month == date.month &&
        yesterday.day == date.day;
    if (isYesterday) {
      return 'i går';
    }

    const weekday = {
      DateTime.monday: 'man.',
      DateTime.tuesday: 'tir.',
      DateTime.wednesday: 'ons.',
      DateTime.thursday: 'tor.',
      DateTime.friday: 'fre.',
      DateTime.saturday: 'lør.',
      DateTime.sunday: 'søn.',
    };

    return weekday[date.weekday] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 10),
                  child: Center(
                    child: Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ),
                ),
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
                  child: FutureBuilder<List<_ChatPreview>>(
                    future: _chatsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const _EmptyChatsState();
                      }

                      final chats = snapshot.data ?? const <_ChatPreview>[];
                      if (chats.isEmpty) {
                        return const _EmptyChatsState();
                      }

                      return ListView.separated(
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
                                  builder: (_) => SecretChatScreen(chatId: chat.id),
                                ),
                              );
                            },
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
                const _Avatar(label: 'BD'),
                const SizedBox(width: 12),
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
                    if (chat.isUsersTurn) ...[
                      const SizedBox(height: 8),
                      const _TurnIndicator(),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: chat.uiProgress.clamp(0.0, 1.0),
                backgroundColor: Colors.black.withOpacity(0.06),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
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

class _TurnIndicator extends StatelessWidget {
  const _TurnIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
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

enum _ChatLockState { locked, ready }

class _ChatPreview {
  final String id;
  final String name;
  final int age;
  final _ChatLockState lockState;
  final String? lastMessage;
  final String time;
  final double progress;
  final bool isUsersTurn;

  const _ChatPreview({
    required this.id,
    required this.name,
    required this.age,
    required this.lockState,
    required this.lastMessage,
    required this.time,
    required this.progress,
    required this.isUsersTurn,
  });

  double get uiProgress => lockState == _ChatLockState.ready ? 1.0 : progress;
}
