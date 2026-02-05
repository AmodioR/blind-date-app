import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../config/supabase_config.dart';
import '../data/chat/chat_models.dart';
import '../data/chat/chat_repository_factory.dart';
import '../sheets/wingman_sheet.dart';
import '../theme/app_colors.dart';
import 'match_profile_screen.dart';

class SecretChatScreen extends StatefulWidget {
  final String? chatId;
  final String? title;
  const SecretChatScreen({super.key, this.chatId, this.title});

  @override
  State<SecretChatScreen> createState() => _SecretChatScreenState();
}

class _SecretChatScreenState extends State<SecretChatScreen> {
  final _repository = ChatRepositoryFactory.create();
  late String _chatName;
  late int _chatAge;
  List<ChatMessage> _messages = const [];
  final Set<String> _optimisticMessageKeys = <String>{};
  bool _isLoading = true;
  RealtimeChannel? _channel;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatName = widget.title ?? 'Nyt match';
    _chatAge = 23;
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.chatId == null) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
      return;
    }

    final threads = await _repository.listThreads();
    ChatThread? thread;
    for (final item in threads) {
      if (item.id == widget.chatId) {
        thread = item;
        break;
      }
    }
    final messages = await _repository.loadMessages(widget.chatId!);

    if (!mounted) {
      return;
    }

    setState(() {
      _chatName = thread?.displayName ?? _chatName;
      _chatAge = thread?.displayAge ?? _chatAge;
      _messages = messages;
      _isLoading = false;
    });

    _subscribeToMatchMessages(matchId: widget.chatId!);
  }

  void _subscribeToMatchMessages({required String matchId}) {
    if (_channel != null ||
        !AppConfig.useRemoteChat ||
        !SupabaseConfig.isConfigured) {
      return;
    }

    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return;
    }

    ChatMessage.currentUserId = user.id;

    _channel = client
        .channel('messages:$matchId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'match_id',
            value: matchId,
          ),
          callback: (payload) {
            final row = payload.newRecord;
            final realtimeMessage = ChatMessage(
              id: row['id'].toString(),
              matchId: row['match_id'].toString(),
              senderId: row['sender_id'].toString(),
              body: row['body'] as String? ?? '',
              createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ??
                  DateTime.now(),
            );

            if (_messages.any((message) => message.id == realtimeMessage.id)) {
              return;
            }

            final optimisticKey =
                _messageKey(senderId: realtimeMessage.senderId, body: realtimeMessage.body);
            if (realtimeMessage.senderId == ChatMessage.currentUserId &&
                _optimisticMessageKeys.remove(optimisticKey)) {
              return;
            }

            final wasNearBottom = _isNearBottom();
            if (!mounted) {
              return;
            }

            setState(() {
              _messages = [..._messages, realtimeMessage];
            });

            if (wasNearBottom) {
              _scrollToBottom(animated: true);
            }
          },
        )
        .subscribe();
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) {
      return true;
    }

    final position = _scrollController.position;
    return (position.maxScrollExtent - position.pixels) <= 72;
  }

  String _messageKey({required String senderId, required String body}) {
    return '$senderId|${body.trim()}';
  }

  void _scrollToBottom({required bool animated}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      final max = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          max,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
        return;
      }
      _scrollController.jumpTo(max);
    });
  }

  @override
  void dispose() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
      _channel = null;
    }
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    final matchId = widget.chatId;
    if (text.isEmpty || matchId == null) {
      return;
    }

    final optimisticMessage = ChatMessage(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      matchId: matchId,
      senderId: ChatMessage.currentUserId,
      body: text,
      createdAt: DateTime.now(),
    );
    final optimisticKey =
        _messageKey(senderId: optimisticMessage.senderId, body: optimisticMessage.body);

    setState(() {
      _messages = [..._messages, optimisticMessage];
      _optimisticMessageKeys.add(optimisticKey);
    });

    _scrollToBottom(animated: true);

    await _repository.sendMessage(matchId: matchId, body: text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final myCount = _messages.where((message) => message.isMe).length;
    final theirCount = _messages.where((message) => !message.isMe).length;
    final progress = min(myCount, theirCount) / 10;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final statusText = clampedProgress >= 1.0 ? 'Klar' : 'Låst';

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: clampedProgress,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFEDE7FF),
                        valueColor:
                            const AlwaysStoppedAnimation(Color(0xFFED4DC1)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          if (message.isMe) {
                            return _MeBubble(text: message.body);
                          }
                          return _OtherBubble(text: message.body);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE6E0F2)),
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _textController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _handleSend(),
                          decoration: const InputDecoration(
                            hintText: 'Skriv en besked…',
                            hintStyle: TextStyle(color: Colors.black38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (_) => const WingmanSheet(),
                        );
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE7FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.waving_hand_outlined,
                            color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: SizedBox(
                height: kToolbarHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      '$_chatName, $_chatAge',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSoft,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.account_circle_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MatchProfileScreen(
                                name: _chatName,
                                age: _chatAge,
                                unlockProgress: clampedProgress,
                                myCount: myCount,
                                theirCount: theirCount,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeBubble extends StatelessWidget {
  final String text;
  const _MeBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class _OtherBubble extends StatelessWidget {
  final String text;
  const _OtherBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E0F2)),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
