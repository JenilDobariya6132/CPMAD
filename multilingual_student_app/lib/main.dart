import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('en');
  await initializeDateFormatting('gu');
  await initializeDateFormatting('hi');

  final prefs = await SharedPreferences.getInstance();

  final savedLanguage =
      prefs.getString('selected_language') ?? 'en';

  runApp(
    MyApp(
      initialLanguage: savedLanguage,
    ),
  );
}