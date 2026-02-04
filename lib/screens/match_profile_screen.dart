import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MatchProfileScreen extends StatelessWidget {
  final String name;
  final int age;

  const MatchProfileScreen({
    super.key,
    required this.name,
    required this.age,
  });

  void _showSafetySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Blokér'),
                onTap: () => _confirmSafetyAction(
                  sheetContext,
                  context,
                  title: 'Blokér',
                  message:
                      'Er du sikker på, at du vil blokere denne profil?',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Rapportér'),
                onTap: () => _confirmSafetyAction(
                  sheetContext,
                  context,
                  title: 'Rapportér',
                  message:
                      'Er du sikker på, at du vil rapportere denne profil?',
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _confirmSafetyAction(
    BuildContext sheetContext,
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuller'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(sheetContext);
                debugPrint('TODO: $title action');
              },
              child: const Text('Bekræft'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bool isProfileReadyToUnlock = false;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.premiumGradient,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 88, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            Container(
                              height: 320,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFED4DC1)
                                        .withValues(alpha: 0.2),
                                    const Color(0xFF8E5BFF)
                                        .withValues(alpha: 0.25),
                                    const Color(0xFFF4A6DE)
                                        .withValues(alpha: 0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border:
                                    Border.all(color: const Color(0xFFD9D0F5)),
                              ),
                            ),
                            Positioned.fill(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                                child: Container(
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Profilen er låst. Lås op ved at lære hinanden at kende.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isProfileReadyToUnlock ? () {} : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isProfileReadyToUnlock
                                ? AppColors.primary
                                : Colors.grey.withValues(alpha: 0.6),
                            disabledBackgroundColor:
                                Colors.grey.withValues(alpha: 0.6),
                            disabledForegroundColor:
                                Colors.white.withValues(alpha: 0.7),
                            padding:
                                const EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: isProfileReadyToUnlock ? 8 : 0,
                          ),
                          child: Text(
                            'Lås op',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(
                                alpha: isProfileReadyToUnlock ? 1 : 0.7,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                            '$name, $age',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSoft,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () => _showSafetySheet(context),
                            ),
                          ),
                        ],
                      ),
                    ),
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
