import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WingmanScreen extends StatelessWidget {
  const WingmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.textSoft,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'AI Wingman',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.wingmanGoldSoft,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 40,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Få ro i maven med korte, sikre svar der føles som dig.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      'Det hjælper jeg med:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    _InfoBullet(text: 'Hvad kan jeg svare?'),
                    SizedBox(height: 10),
                    _InfoBullet(text: 'Hvad kan jeg spørge om?'),
                    SizedBox(height: 10),
                    _InfoBullet(text: 'Er det her for meget?'),
                    SizedBox(height: 18),
                    _ValueCueRow(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  backgroundColor: AppColors.primary,
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
            color: Colors.black,
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
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValueCueRow extends StatelessWidget {
  const _ValueCueRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: const [
        _ValueChip(text: 'Mere selvtillid'),
        _ValueChip(text: 'Undgå akavede svar'),
      ],
    );
  }
}

class _ValueChip extends StatelessWidget {
  const _ValueChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
