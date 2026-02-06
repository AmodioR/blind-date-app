import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile/profile_repository_factory.dart';
import '../data/profile/profile_model.dart';
import 'enroll_screen.dart';
import 'landing_screen.dart';
import 'main_tab_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? _currentSession;
  Future<Profile?>? _profileFuture;
  _AuthDestination? _lastDestination;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    _currentSession = client.auth.currentSession;
    if (_currentSession != null) {
      _profileFuture = ProfileRepositoryFactory.create().loadProfile();
    }
  }

  void _updateSession(Session? session) {
    if (_currentSession?.accessToken == session?.accessToken) {
      return;
    }
    setState(() {
      _currentSession = session;
      _lastDestination = null;
      if (session == null) {
        _profileFuture = Future.value(null);
      } else {
        _profileFuture = ProfileRepositoryFactory.create().loadProfile();
      }
    });
  }

  void _scheduleSessionUpdate(Session? session) {
    if (_currentSession?.accessToken == session?.accessToken) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _updateSession(session);
    });
  }

  void _scheduleNavigation(_AuthDestination destination, Widget screen) {
    if (_lastDestination == destination) {
      return;
    }
    _lastDestination = destination;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => screen),
        (route) => route.isFirst,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? client.auth.currentSession;
        _scheduleSessionUpdate(session);
        if (session != null) {
          final profileFuture = _profileFuture;
          if (profileFuture == null) {
            return const _AuthLoadingScreen();
          }
          return FutureBuilder<Profile?>(
            future: profileFuture,
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState != ConnectionState.done) {
                return const _AuthLoadingScreen();
              }
              if (profileSnapshot.data == null) {
                _scheduleNavigation(
                  _AuthDestination.enroll,
                  const EnrollScreen(),
                );
                return const _AuthLoadingScreen();
              }
              _scheduleNavigation(
                _AuthDestination.main,
                const MainTabScreen(),
              );
              return const _AuthLoadingScreen();
            },
          );
        }
        _scheduleNavigation(
          _AuthDestination.landing,
          const LandingScreen(),
        );
        return const _AuthLoadingScreen();
      },
    );
  }
}

enum _AuthDestination { landing, enroll, main }

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
