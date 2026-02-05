import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../theme/app_colors.dart';
import 'enroll_screen.dart';
import 'main_shell.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<void> _handleEntry(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  Future<void> _showEmailSheet(
    BuildContext context, {
    required bool shouldCreateUser,
  }) async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isSending = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> submit() async {
              if (isSending) return;
              final email = emailController.text.trim();
              final password = passwordController.text;
              if (email.isEmpty || !email.contains('@')) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  const SnackBar(content: Text('Indtast en gyldig email.')),
                );
                return;
              }
              if (password.trim().isEmpty) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  const SnackBar(content: Text('Indtast en adgangskode.')),
                );
                return;
              }
              setSheetState(() {
                isSending = true;
              });
              try {
                if (shouldCreateUser) {
                  await Supabase.instance.client.auth.signUp(
                    email: email,
                    password: password,
                  );
                } else {
                  await Supabase.instance.client.auth.signInWithPassword(
                    email: email,
                    password: password,
                  );
                }
                if (!sheetContext.mounted) return;
                Navigator.of(sheetContext).pop();
              } on AuthException {
                if (!sheetContext.mounted) return;
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      shouldCreateUser
                          ? 'Kunne ikke oprette konto'
                          : 'Forkert email eller adgangskode',
                    ),
                  ),
                );
              } catch (_) {
                if (!sheetContext.mounted) return;
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  const SnackBar(content: Text('Noget gik galt. Prøv igen.')),
                );
              } finally {
                setSheetState(() {
                  isSending = false;
                });
              }
            }

            final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, bottomPadding + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    shouldCreateUser ? 'Opret konto' : 'Log ind',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Adgangskode',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isSending ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      isSending ? 'Arbejder...' : 'Fortsæt',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    emailController.dispose();
    passwordController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    height: 220,
                    child: Image.asset(
                      'assets/images/BDV4.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (SupabaseConfig.isConfigured) {
                      _showEmailSheet(context, shouldCreateUser: false);
                    } else {
                      _handleEntry(context);
                    }
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
                    'Log ind',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {
                    if (SupabaseConfig.isConfigured) {
                      _showEmailSheet(context, shouldCreateUser: true);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EnrollScreen()),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    foregroundColor: AppColors.primaryDeep,
                  ),
                  child: const Text(
                    'Opret konto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
