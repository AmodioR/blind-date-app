import 'package:flutter/material.dart';

class WingmanScreen extends StatelessWidget {
  const WingmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Wingman'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'AI Wingman',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B2E),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Få hurtig og diskret sparring på dine beskeder, når du vil fremstå'
              ' naturlig og sikker.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF5E5A71),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Det hjælper jeg med:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3D3855),
              ),
            ),
            const SizedBox(height: 12),
            _InfoBullet(text: 'Hvad kan jeg svare?'),
            const SizedBox(height: 10),
            _InfoBullet(text: 'Hvad kan jeg spørge om?'),
            const SizedBox(height: 10),
            _InfoBullet(text: 'Er det her for meget?'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4AB6),
                padding: const EdgeInsets.symmetric(vertical: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Abonnér',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBullet extends StatelessWidget {
  const _InfoBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          height: 6,
          width: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF6C4AB6),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
              color: Color(0xFF3D3855),
            ),
          ),
        ),
      ],
    );
  }
}
