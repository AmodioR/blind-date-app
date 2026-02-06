import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/profile/profile_repository_factory.dart';
import '../data/profile/profile_model.dart';
import 'app_session.dart';
import 'enroll_screen.dart';
import 'landing_screen.dart';
import 'main_tab_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _activeAccessToken;
  Future<_InitResult>? _initFuture;

  @override
  void initState() {
    super.initState();
    _handleSessionChanged(Supabase.instance.client.auth.currentSession);
  }

  void _handleSessionChanged(Session? session) {
    final accessToken = session?.accessToken;
    if (_activeAccessToken == accessToken) {
      return;
    }

    _activeAccessToken = accessToken;
    if (accessToken == null) {
      _initFuture = null;
      setState(() {});
      return;
    }

    _startInitialization();
  }

  void _startInitialization() {
    setState(() {
      _initFuture = _initializeAuthenticatedApp();
    });
  }

  Future<_InitResult> _initializeAuthenticatedApp() async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) {
        return const _InitResult.unauthenticated();
      }

      final profile = await ProfileRepositoryFactory.create().loadProfile();
      if (profile == null) {
        return const _InitResult.profileMissing();
      }

      final appSession = AppSession(userId: user.id, profile: profile);
      return _InitResult.ready(appSession);
    } catch (error) {
      return _InitResult.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? client.auth.currentSession;
        _handleSessionChanged(session);

        if (session == null) {
          return const LandingScreen();
        }

        final initFuture = _initFuture;
        if (initFuture == null) {
          return const _AppLoadingScreen();
        }

        return FutureBuilder<_InitResult>(
          future: initFuture,
          builder: (context, initSnapshot) {
            if (initSnapshot.connectionState != ConnectionState.done) {
              return const _AppLoadingScreen();
            }

            final result = initSnapshot.data;
            if (result == null) {
              return _InitErrorScreen(onRetry: _startInitialization);
            }

            if (result.status == _InitStatus.error) {
              return _InitErrorScreen(onRetry: _startInitialization);
            }

            if (result.status == _InitStatus.unauthenticated) {
              return const LandingScreen();
            }

            if (result.status == _InitStatus.profileMissing) {
              return EnrollScreen(onCompleted: _startInitialization);
            }

            final appSession = result.session;
            if (appSession == null) {
              return _InitErrorScreen(onRetry: _startInitialization);
            }

            return MainTabScreen(
              appSession: appSession,
              onLogout: () async {
                await client.auth.signOut();
              },
            );
          },
        );
      },
    );
  }
}

enum _InitStatus { unauthenticated, profileMissing, ready, error }

class _InitResult {
  const _InitResult._({
    required this.status,
    this.session,
    this.error,
  });

  const _InitResult.unauthenticated() : this._(status: _InitStatus.unauthenticated);

  const _InitResult.profileMissing() : this._(status: _InitStatus.profileMissing);

  const _InitResult.ready(AppSession appSession)
      : this._(status: _InitStatus.ready, session: appSession);

  const _InitResult.error(Object error)
      : this._(status: _InitStatus.error, error: error);

  final _InitStatus status;
  final AppSession? session;
  final Object? error;
}

class _AppLoadingScreen extends StatelessWidget {
  const _AppLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _InitErrorScreen extends StatelessWidget {
  const _InitErrorScreen({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Noget gik galt under opstarten.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Prøv igen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
