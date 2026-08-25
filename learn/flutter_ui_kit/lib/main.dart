import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/onboarding/onboarding_screen.dart';

void main() {
  runApp(const UIKitApp());
}

class UIKitApp extends StatelessWidget {
  const UIKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
