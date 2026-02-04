import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Profil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F2A3A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$name, $age',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2F2A3A),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE6E0F2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Profilen er låst',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2F2A3A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lås op ved at lære hinanden at kende.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.more_horiz),
                color: const Color(0xFF2F2A3A),
                onPressed: () => _showSafetySheet(context),
              ),
            ),
            Positioned(
              top: 8,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: const Color(0xFF2F2A3A),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F0FF),
    );
  }
}
