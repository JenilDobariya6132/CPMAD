import 'package:flutter/material.dart';
import 'screens/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Registration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegistrationPage(),
    );
  }
}
