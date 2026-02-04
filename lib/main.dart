import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/landing_screen.dart';
import 'screens/main_shell.dart';
import 'theme/app_colors.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(BlindDateApp(isLoggedIn: isLoggedIn));
}

class BlindDateApp extends StatelessWidget {
  const BlindDateApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

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

      home: isLoggedIn ? const MainShell() : const LandingScreen(),
    );
  }
}
