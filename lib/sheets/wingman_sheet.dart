import 'package:flutter/material.dart';

class WingmanSheet extends StatelessWidget {
  const WingmanSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sidder du fast? 👋',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jeg er din personlige Wingman',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('Hvad kan jeg svare?'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text('Hvad kan jeg spørge om?'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Er det her for meget?'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
