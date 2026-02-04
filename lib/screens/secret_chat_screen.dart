import 'package:flutter/material.dart';
import '../sheets/wingman_sheet.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
