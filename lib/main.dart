import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/open_chats_screen.dart';
import 'screens/account_screen.dart';
import 'theme/app_colors.dart';



void main() {
  runApp(const BlindDateApp());
}

class BlindDateApp extends StatelessWidget {
  const BlindDateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blind Date',
      theme: ThemeData(
  scaffoldBackgroundColor: AppColors.bg,
  fontFamily: 'SNPro',
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ),
),

      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    OpenChatsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight + 16,
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          selectedItemColor: const Color(0xFF6C4AB6),
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


