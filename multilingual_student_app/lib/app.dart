import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';

class MyApp extends StatefulWidget {
  final String initialLanguage;

  const MyApp({
    super.key,
    required this.initialLanguage,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();

    _locale = Locale(
      widget.initialLanguage,
    );
  }

  Future<void> changeLanguage(
    String language,
  ) async {
    await LanguageService.saveLanguage(
      language,
    );

    setState(() {
      _locale = Locale(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Student Information',

      locale: _locale,

      supportedLocales: const [
        Locale('en'),
        Locale('gu'),
        Locale('hi'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: HomeScreen(
        selectedLanguage: _locale.languageCode,

        onLanguageChanged: changeLanguage,
      ),
    );
  }
}