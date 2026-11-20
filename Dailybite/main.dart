import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/firebase_bootstrap.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Safe no-op while the project has no Firebase config files yet.
  await FirebaseBootstrap.init();

  runApp(const DailyBiteApp());
}

class DailyBiteApp extends StatefulWidget {
  const DailyBiteApp({super.key});

  @override
  State<DailyBiteApp> createState() => _DailyBiteAppState();
}

class _DailyBiteAppState extends State<DailyBiteApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyBite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: HomeScreen(
        themeMode: _themeMode,
        onToggleThemeMode: _toggleThemeMode,
      ),
    );
  }
}
