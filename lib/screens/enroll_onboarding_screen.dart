import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'enroll_draft.dart';
import 'enroll_profile_screen.dart';

class EnrollOnboardingScreen extends StatelessWidget {
  const EnrollOnboardingScreen({super.key, this.draft = const EnrollDraft()});

  final EnrollDraft draft;

  @override
  Widget build(BuildContext context) {
    const points = [
      'Ingen billeder i starten',
      'Chat først (10 beskeder hver)',
      'Begge vælger, hvornår billeder låses op',
      'Du bestemmer selv tempoet',
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.premiumGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '1 af 3',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Sådan virker Blind Date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                ...points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            '•',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EnrollProfileScreen(draft: draft),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Fortsæt',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
