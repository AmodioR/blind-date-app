import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import 'account_screen.dart';
import 'app_session.dart';
import 'home_screen.dart';
import 'open_chats_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  AppSession _sessionOf(BuildContext context) {
    final session = ModalRoute.of(context)?.settings.arguments;
    if (session is AppSession) {
      return session;
    }

    throw StateError(
      'MainShell requires an AppSession route argument.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = _sessionOf(context);

    final pages = [
      const HomeScreen(),
      OpenChatsScreen(currentUserId: session.userId),
      AccountScreen(
        initialProfile: session.profile,
        onLogout: () => Supabase.instance.client.auth.signOut(),
      ),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight + 16,
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black45,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Konto',
            ),
          ],
        ),
      ),
    );
  }
}
