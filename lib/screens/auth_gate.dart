import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile/profile_repository_factory.dart';
import '../data/profile/profile_model.dart';
import 'enroll_screen.dart';
import 'landing_screen.dart';
import 'main_tab_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? client.auth.currentSession;
        if (session != null) {
          final profileRepository = ProfileRepositoryFactory.create();
          return FutureBuilder<Profile?>(
            future: profileRepository.loadProfile(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState != ConnectionState.done) {
                return const _AuthLoadingScreen();
              }
              if (profileSnapshot.data == null) {
                return const EnrollScreen();
              }
              return const MainTabScreen();
            },
          );
        }
        return const LandingScreen();
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
