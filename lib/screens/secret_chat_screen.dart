import 'package:flutter/material.dart';
import '../sheets/wingman_sheet.dart';

class SecretChatScreen extends StatelessWidget {
  final String title;
  const SecretChatScreen({super.key, required this.title});


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),

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
              children: const [
                _OtherBubble(
                  text:
                      'Hej 😄 Jeg synes virkelig konceptet her er fedt. Det føles meget mere ægte.',
                ),
                _MeBubble(
                  text:
                      'Tak! Jeg er helt enig. Det er meget rarere at lære hinanden at kende først 😊',
                ),
                _OtherBubble(
                  text: 'Helt sikkert! Hvad laver du normalt i din fritid?',
                ),
                _MeBubble(
                  text: 'Jeg laver faktisk musik og gamer en del. Hvad med dig?',
                ),
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
