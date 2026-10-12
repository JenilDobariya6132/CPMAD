import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AnimatedProductApp());
}

class AnimatedProductApp extends StatelessWidget {
  const AnimatedProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopVibe — Animated Product App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const OnboardingScreen(),
    );
  }
}
