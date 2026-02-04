import 'dart:math';

import 'package:flutter/material.dart';
import '../sheets/wingman_sheet.dart';
import '../theme/app_colors.dart';
import 'match_profile_screen.dart';

class SecretChatScreen extends StatelessWidget {
  final String? chatId;
  final String? title;
  const SecretChatScreen({super.key, this.chatId, this.title});

  @override
  Widget build(BuildContext context) {
    final chatData = chatId == null
        ? ChatData(
            name: title ?? 'Nyt match',
            age: 23,
            messages: const [],
          )
        : chatConversations[chatId] ??
            ChatData(
              name: title ?? 'Nyt match',
              age: 23,
              messages: const [
                ChatMessage(
                  text:
                      'Hej 😄 Jeg synes virkelig konceptet her er fedt. Det føles meget mere ægte.',
                  isMe: false,
                ),
                ChatMessage(
                  text:
                      'Tak! Jeg er helt enig. Det er meget rarere at lære hinanden at kende først 😊',
                  isMe: true,
                ),
                ChatMessage(
                  text: 'Helt sikkert! Hvad laver du normalt i din fritid?',
                  isMe: false,
                ),
                ChatMessage(
                  text: 'Jeg laver faktisk musik og gamer en del. Hvad med dig?',
                  isMe: true,
                ),
              ],
            );
    final messages = chatData.messages;
    final myCount = messages.where((message) => message.isMe).length;
    final theirCount = messages.length - myCount;
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

              // Chat list (dummy)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  children: [
                    for (final message in chatData.messages)
                      if (message.isMe)
                        _MeBubble(text: message.text)
                      else
                        _OtherBubble(text: message.text),
                  ],
                ),
              ),

              // Input bar + Wingman hand
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
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Skriv en besked…',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        showModalBottomSheet(
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
                      '${chatData.name}, ${chatData.age}',
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
                                name: chatData.name,
                                age: chatData.age,
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

class ChatData {
  final String name;
  final int age;
  final List<ChatMessage> messages;

  const ChatData({
    required this.name,
    required this.age,
    required this.messages,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;

  const ChatMessage({
    required this.text,
    required this.isMe,
  });
}

const Map<String, ChatData> chatConversations = {
  'jonas-24': ChatData(
    name: 'Jonas',
    age: 24,
    messages: const [
      ChatMessage(
        text: 'Godmorgen! Har du fået din kaffe endnu?',
        isMe: false,
      ),
      ChatMessage(
        text: 'Ja! Og jeg prøver en ny bønne i dag ☕️',
        isMe: true,
      ),
      ChatMessage(
        text: 'Nice, jeg er mere te-person. Hvad er dit go-to humørboost?',
        isMe: false,
      ),
    ],
  ),
  'magnus-22': ChatData(
    name: 'Magnus',
    age: 22,
    messages: const [
      ChatMessage(
        text: 'Godmorgen, sovet godt?',
        isMe: false,
      ),
      ChatMessage(
        text: 'Ja, helt roligt i nat.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Hvad skal din dag?',
        isMe: false,
      ),
      ChatMessage(
        text: 'Arbejde og lidt træning.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Lyder fint. Hvilken træning?',
        isMe: false,
      ),
      ChatMessage(
        text: 'En kort løbetur.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Jeg går en tur senere.',
        isMe: false,
      ),
      ChatMessage(
        text: 'Det gør godt.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Har du frokostplaner?',
        isMe: false,
      ),
      ChatMessage(
        text: 'Salat og kaffe.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Kaffe er altid godt.',
        isMe: false,
      ),
      ChatMessage(
        text: 'Helt enig.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Hvilken musik nu?',
        isMe: false,
      ),
      ChatMessage(
        text: 'Rolig indie i dag.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Det passer til vejret.',
        isMe: false,
      ),
      ChatMessage(
        text: 'Ja, det gør.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Skal vi lave playlisten?',
        isMe: false,
      ),
      ChatMessage(
        text: 'Gerne, send dine favoritter.',
        isMe: true,
      ),
      ChatMessage(
        text: 'Jeg sender et par.',
        isMe: false,
      ),
      ChatMessage(
        text: 'Fedt, jeg glæder mig.',
        isMe: true,
      ),
    ],
  ),
  'oscar-25': ChatData(
    name: 'Oscar',
    age: 25,
    messages: const [
      ChatMessage(
        text: 'Jeg tror vi ville være gode til at rejse sammen.',
        isMe: false,
      ),
      ChatMessage(
        text: 'Helt enig! Hvad er dit næste drømmerejsemål?',
        isMe: true,
      ),
      ChatMessage(
        text: 'Japan. Street food + neon. Hvordan med dig?',
        isMe: false,
      ),
    ],
  ),
  'sara-23': ChatData(
    name: 'Sara',
    age: 23,
    messages: const [
      ChatMessage(
        text: 'Hej! Jeg kan se vi begge elsker brunch.',
        isMe: false,
      ),
      ChatMessage(
        text: 'Det er mit yndlingsmåltid. Har du et favoritsted?',
        isMe: true,
      ),
      ChatMessage(
        text: 'Jeg har en lille café jeg elsker. Vil du have navnet?',
        isMe: false,
      ),
    ],
  ),
};

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
