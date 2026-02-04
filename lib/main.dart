import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

      home: const LandingScreen(),
    );
  }
}
