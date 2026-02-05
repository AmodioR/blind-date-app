import 'dart:math';

import 'package:flutter/material.dart';

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
  bool _isLoading = true;

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
  }

  @override
  void dispose() {
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

    await _repository.sendMessage(matchId: matchId, body: text);
    _textController.clear();
    await _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
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
