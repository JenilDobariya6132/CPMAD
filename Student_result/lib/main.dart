import 'package:flutter/material.dart';

import 'screens/result_screen.dart';

void main() {
  runApp(const StudentResultApp());
}

class StudentResultApp extends StatelessWidget {
  const StudentResultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Result Calculator',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),

      home: const ResultScreen(),
    );
  }
}