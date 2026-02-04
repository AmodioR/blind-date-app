import 'package:flutter/material.dart';
import '../sheets/wingman_sheet.dart';

class SecretChatScreen extends StatelessWidget {
  final String? chatId;
  final String? title;
  const SecretChatScreen({super.key, this.chatId, this.title});


  @override
  Widget build(BuildContext context) {
    final chatData = chatId == null
        ? _ChatData(
            name: title ?? 'Nyt match',
            age: 23,
            messages: const [],
          )
        : _chatConversations[chatId] ??
            _ChatData(
              name: title ?? 'Nyt match',
              age: 23,
              messages: const [
                _ChatMessage(
                  text:
                      'Hej 😄 Jeg synes virkelig konceptet her er fedt. Det føles meget mere ægte.',
                  isMe: false,
                ),
                _ChatMessage(
                  text:
                      'Tak! Jeg er helt enig. Det er meget rarere at lære hinanden at kende først 😊',
                  isMe: true,
                ),
                _ChatMessage(
                  text: 'Helt sikkert! Hvad laver du normalt i din fritid?',
                  isMe: false,
                ),
                _ChatMessage(
                  text: 'Jeg laver faktisk musik og gamer en del. Hvad med dig?',
                  isMe: true,
                ),
              ],
            );

    return Scaffold(
      appBar: AppBar(
        title: Text(chatData.name),

        centerTitle: true,
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Lock banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6E0F2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, size: 18, color: Colors.black54),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Billeder låst – Lær hinanden at kende først',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${chatData.name}, ${chatData.age}',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Du: 6/10  ·  Dem: 7/10',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
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
                        color: Color(0xFF6C4AB6)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatData {
  final String name;
  final int age;
  final List<_ChatMessage> messages;

  const _ChatData({
    required this.name,
    required this.age,
    required this.messages,
  });
}

class _ChatMessage {
  final String text;
  final bool isMe;

  const _ChatMessage({
    required this.text,
    required this.isMe,
  });
}

const Map<String, _ChatData> _chatConversations = {
  'jonas-24': _ChatData(
    name: 'Jonas',
    age: 24,
    messages: const [
      _ChatMessage(
        text: 'Godmorgen! Har du fået din kaffe endnu?',
        isMe: false,
      ),
      _ChatMessage(
        text: 'Ja! Og jeg prøver en ny bønne i dag ☕️',
        isMe: true,
      ),
      _ChatMessage(
        text: 'Nice, jeg er mere te-person. Hvad er dit go-to humørboost?',
        isMe: false,
      ),
    ],
  ),
  'magnus-22': _ChatData(
    name: 'Magnus',
    age: 22,
    messages: const [
      _ChatMessage(
        text: 'Hvilken type musik får dig altid i godt humør?',
        isMe: false,
      ),
      _ChatMessage(
        text: 'Indie pop eller noget med god energi. Dig?',
        isMe: true,
      ),
      _ChatMessage(
        text: 'Jeg er 90’er rock hele vejen. Skal vi lave en playliste?',
        isMe: false,
      ),
    ],
  ),
  'oscar-25': _ChatData(
    name: 'Oscar',
    age: 25,
    messages: const [
      _ChatMessage(
        text: 'Jeg tror vi ville være gode til at rejse sammen.',
        isMe: false,
      ),
      _ChatMessage(
        text: 'Helt enig! Hvad er dit næste drømmerejsemål?',
        isMe: true,
      ),
      _ChatMessage(
        text: 'Japan. Street food + neon. Hvordan med dig?',
        isMe: false,
      ),
    ],
  ),
  'sara-23': _ChatData(
    name: 'Sara',
    age: 23,
    messages: const [
      _ChatMessage(
        text: 'Hej! Jeg kan se vi begge elsker brunch.',
        isMe: false,
      ),
      _ChatMessage(
        text: 'Det er mit yndlingsmåltid. Har du et favoritsted?',
        isMe: true,
      ),
      _ChatMessage(
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
            color: const Color(0xFF6C4AB6),
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
