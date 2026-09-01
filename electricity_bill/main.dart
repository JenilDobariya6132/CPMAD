import 'package:flutter/material.dart';

import 'screens/bill_screen.dart';

void main() {
  runApp(
    const ElectricityBillApp(),
  );
}

class ElectricityBillApp extends StatelessWidget {
  const ElectricityBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Electricity Bill Calculator',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),

        useMaterial3: true,
      ),

      home: const BillScreen(),
    );
  }
}