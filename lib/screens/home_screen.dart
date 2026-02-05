import 'package:flutter/material.dart';
import '../data/matchmaking/matchmaking_repository_factory.dart';
import '../theme/app_colors.dart';
import 'secret_chat_screen.dart';
import 'wingman_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _findBlindDate(BuildContext context) async {
    final matchId =
        await MatchmakingRepositoryFactory.create().findBlindDateMatchId();

    if (!context.mounted) {
      return;
    }

    if (matchId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SecretChatScreen(chatId: matchId, title: 'Nyt match'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingen matches lige nu – prøv igen senere'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Container(
  decoration: const BoxDecoration(
    gradient: AppColors.premiumGradient,
  ),
  child: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: double.infinity,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: SizedBox(
                            height: 280,
                            child: Image.asset(
                              'assets/images/BDV4.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            // Wingman teaser (small, app-like)
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => WingmanScreen()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.wingmanGoldGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: const Color(0xFFD9D0F5)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.waving_hand_outlined,
                                        color: Colors.black, size: 18),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Wingman Premium: få hjælp til næste besked',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.chevron_right,
                                        color: Colors.black45),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Status card (app-like)
                            Container(
                              height: 132,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFED4DC1),
                                    Color(0xFFF4A6DE),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x22000000),
                                    blurRadius: 18,
                                    offset: Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Color(0x449B7BE8),
                                    blurRadius: 80,
                                    offset: Offset(0, 24),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 54,
                                      width: 54,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(18),
                                        border:
                                            Border.all(color: AppColors.border),
                                      ),
                                      child: const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.white,
                                          size: 26),
                                    ),
                                    const SizedBox(width: 14),
                                    const Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Blind Date',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'Personlighed først.\nBilleder kommer senere.',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Main action area
                            ElevatedButton(
                              onPressed: () => _findBlindDate(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 22),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 8,
                              ),
                              child: const Text(
                                'Find blind date',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  ),
)

    );
  }
}
