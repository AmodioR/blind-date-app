import 'package:flutter/material.dart';
import '../theme/app_colors.dart';



class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Min konto'),
        centerTitle: true,
        backgroundColor: AppColors.bgSoft,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile card
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
                child: Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7FF),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFD9D0F5)),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF6C4AB6),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Din profil',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Redigering kommer snart',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Settings / info card
              _AccountPlaceholderTile(
                icon: Icons.lock_outline,
                title: 'Privatliv & sikkerhed',
                subtitle: 'Blokering, rapportering og tryghed',
              ),
              _AccountPlaceholderTile(
                icon: Icons.favorite_border,
                title: 'Dine matches',
                subtitle: 'Se dine nuværende forbindelser',
              ),
              _AccountPlaceholderTile(
                icon: Icons.waving_hand_outlined,
                title: 'Wingman Premium',
                subtitle: 'Personlig hjælp til dine beskeder',
              ),

              const Spacer(),

              // Footer note (calm, honest)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6E0F2)),
                ),
                child: const Text(
                  'Denne del af appen er under udvikling.\n'
                  'Fokus er lige nu på samtaler og connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
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

class _AccountPlaceholderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AccountPlaceholderTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E0F2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6C4AB6)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
