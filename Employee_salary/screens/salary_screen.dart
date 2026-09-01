import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../widgets/salary_result_card.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController salaryController =
      TextEditingController();

  Employee? employee;

  void calculateSalary() {
    String name = nameController.text.trim();
    String salaryText = salaryController.text.trim();

    if (name.isEmpty) {
      showMessage('Please enter employee name.');
      return;
    }

    if (salaryText.isEmpty) {
      showMessage('Please enter salary.');
      return;
    }

    double? salary = double.tryParse(salaryText);

    if (salary == null || salary <= 0) {
      showMessage('Please enter a valid salary.');
      return;
    }

    setState(() {
      employee = Employee(
        name: name,
        grossSalary: salary,
      );
    });
  }

  void clearData() {
    nameController.clear();
    salaryController.clear();

    setState(() {
      employee = null;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Salary Calculator',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Icon(
              Icons.account_balance_wallet,
              size: 70,
              color: Colors.indigo,
            ),

            const SizedBox(height: 10),

            const Text(
              'Employee Salary Calculator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Employee Name',
                hintText: 'Enter employee name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Gross Salary',
                hintText: 'Enter gross salary',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: calculateSalary,
              icon: const Icon(Icons.calculate),
              label: const Text(
                'Calculate Salary',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: clearData,
              icon: const Icon(Icons.clear),
              label: const Text('Clear'),
            ),

            if (employee != null)
              SalaryResultCard(
                employee: employee!,
              ),
          ],
        ),
      ),
    );
  }
}