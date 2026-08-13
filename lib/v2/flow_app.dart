import 'package:flutter/material.dart';
import 'interactive_app.dart';
import 'onboarding_flow.dart';

class BlindDateV2FlowApp extends StatefulWidget {
  const BlindDateV2FlowApp({super.key});

  @override
  State<BlindDateV2FlowApp> createState() => _BlindDateV2FlowAppState();
}

class _BlindDateV2FlowAppState extends State<BlindDateV2FlowApp> {
  bool _onboardingComplete = false;

  @override
  Widget build(BuildContext context) {
    if (_onboardingComplete) {
      return const BlindDateV2InteractiveApp();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlindDate 2.0',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SNPro',
        scaffoldBackgroundColor: const Color(0xFFFFF8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF13BB7)),
      ),
      home: OnboardingFlow(
        onComplete: () => setState(() => _onboardingComplete = true),
      ),
    );
  }
}
