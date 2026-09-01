import 'package:flutter/material.dart';

import 'screens/salary_screen.dart';

void main() {
  runApp(const EmployeeSalaryApp());
}

class EmployeeSalaryApp extends StatelessWidget {
  const EmployeeSalaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Employee Salary Calculator',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),

      home: const SalaryScreen(),
    );
  }
}