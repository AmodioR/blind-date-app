import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'screens/auth_gate.dart';
import 'screens/landing_screen.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }
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
      home: SupabaseConfig.isConfigured
          ? const AuthGate()
          : const LandingScreen(),
    );
  }
}
