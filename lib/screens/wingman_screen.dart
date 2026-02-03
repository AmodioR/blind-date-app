import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class WingmanScreen extends StatelessWidget {
  const WingmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wingman'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wingman Premium 👋',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Få hjælp til dine beskeder:\n'
                    '• Hvad kan jeg svare?\n'
                    '• Hvad kan jeg spørge om?\n'
                    '• Er det her for meget?',
                    style: TextStyle(color: Colors.black54, height: 1.35),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: null, // kommer senere
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4AB6),
                disabledBackgroundColor: const Color(0xFF6C4AB6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Abonnér (kommer snart)',
                style: TextStyle(
                  fontSize: 16,
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
